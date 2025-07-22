{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.network.reverse-proxy.caddy;
  proxies = config.system-modules.services.network.reverse-proxy.proxies;
  domain = config.system-modules.services.network.domains.homelab;
  certPath = "/var/lib/acme/${domain}/fullchain.pem";
  keyPath = "/var/lib/acme/${domain}/key.pem";
  mailAddress = "pepijn.pve@gmail.com";
  makeReverseProxyHttps = http-proxy: {
    name = "${http-proxy.subdomain}.${domain}";
    value.extraConfig = ''
      ${
        if http-proxy.require-auth then
          ''
            forward_auth 127.0.0.1:${builtins.toString config.system-modules.services.auth.authelia.port} {
              uri /api/authz/forward-auth
              copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
            }
          ''
        else
          ""
      }
      reverse_proxy ${http-proxy.redirect-address}:${builtins.toString http-proxy.port} {
        ${http-proxy.extra-config}
      }
    '';
  };
  makeReverseProxyTcp = tcp-proxy: ''
    @${tcp-proxy.subdomain} tls sni ${tcp-proxy.subdomain}.${domain}
    route @${tcp-proxy.subdomain} {
      tls ${certPath}${keyPath}
      proxy {
        upstream ${tcp-proxy.redirect-address}:${builtins.toString tcp-proxy.port}          
      }
    }
  '';
  httpsProxies = lib.filter (p: p.type == "https") proxies;
  tcpProxies = lib.filter (p: p.type == "tcp") proxies;
  tcpPorts = map (p: p.port) tcpProxies;

in
{
  config = lib.mkIf module.enable {
    users.users.caddy.extraGroups = [ "acme" ];

    services.caddy = {
      enable = true;
      email = mailAddress;

      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/mholt/caddy-l4@v0.0.0-20250530154005-4d3c80e89c5f" ];
        hash = "sha256-O2shDuAA4OjUx44uOxMbd5iQUQVl6GUuFKqv+P/PXNM=";
      };
      virtualHosts = {
        "${domain}".extraConfig = ''
          respond "Hello World"
        '';
      }
      // builtins.listToAttrs (map makeReverseProxyHttps httpsProxies);

      globalConfig = ''
        layer4 {
          :443 {
            ${builtins.concatStringsSep "\n\n" (map makeReverseProxyTcp tcpProxies)}
          }
        }
      '';
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ]
    ++ tcpPorts;
  };
}
