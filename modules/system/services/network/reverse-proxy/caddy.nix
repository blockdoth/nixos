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
  mailAddress = config.system-modules.secrets.mails.personal;
  makeReverseProxyHttps = http-proxy: {
    name = "${http-proxy.subdomain}.${http-proxy.domain}";
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
    @${tcp-proxy.subdomain} tls sni ${tcp-proxy.subdomain}.${tcp-proxy.domain}
    route @${tcp-proxy.subdomain} {
      tls 
      proxy ${tcp-proxy.redirect-address}:${builtins.toString tcp-proxy.port}
    }
  '';
  makeTcpCerts = tcp-proxy: {
    name = "${tcp-proxy.subdomain}.${tcp-proxy.domain}";
    value.extraConfig = "abort"; # Fake route to trick caddy into getting certs
  };

  makeHelloWorld = domain: {
    name = domain; # the key of the virtualHost
    value = {
      extraConfig = ''
        respond "Hello World"
      '';
    };
  };

  httpsProxies = lib.filter (p: p.type == "https") proxies;
  tcpProxies = lib.filter (p: p.type == "tcp") proxies;
  tcpPorts = map (p: p.port) tcpProxies;
  domains = map (p: p.domain) proxies;
in
{
  config = lib.mkIf module.enable {
    users.users.caddy.extraGroups = [ "acme" ];

    services.caddy = {
      enable = true;
      email = mailAddress;

      package = pkgs.caddy.withPlugins {
        # L4 tcp proxying package
        plugins = [ "github.com/mholt/caddy-l4@v0.0.0-20250530154005-4d3c80e89c5f" ];
        hash = "sha256-O2shDuAA4OjUx44uOxMbd5iQUQVl6GUuFKqv+P/PXNM=";
      };
      virtualHosts =
        builtins.listToAttrs (map makeHelloWorld domains)
        // builtins.listToAttrs (map makeReverseProxyHttps httpsProxies)
        // builtins.listToAttrs (map makeTcpCerts tcpProxies);

      globalConfig = ''
        metrics
        layer4 {
          :443 {
            ${builtins.concatStringsSep "\n\n" (map makeReverseProxyTcp tcpProxies)}
          }
        }
      '';
    };

    networking.firewall.allowedTCPPorts = tcpPorts ++ [
      80
      443
    ];
  };
}
