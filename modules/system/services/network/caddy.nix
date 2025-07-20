{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.network.caddy;
  domain = config.system-modules.services.network.domains.homelab;
  certPath = "/var/lib/acme/${domain}/fullchain.pem";
  keyPath = "/var/lib/acme/${domain}/privkey.pem";
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
  makeReverseProxyTcp = tcp-proxy: {
    name = "${tcp-proxy.subdomain}.${domain}";
    value.extraConfig = ''
      :${toString tcp-proxy.port} {
        reverse_proxy ${tcp-proxy.redirect-address}:${builtins.toString tcp-proxy.port} {
          transport tcp
        }
      }
    '';
  };
  httpsProxies = lib.filter (p: p.type == "https") module.reverse-proxies;
  tcpProxies = lib.filter (p: p.type == "tcp") module.reverse-proxies;
  tcpPorts = map (p: p.port) tcpProxies;

in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      caddy
    ];
    users.users.caddy.extraGroups = [ "acme" ];

    services.caddy = {
      enable = true;
      email = mailAddress;

      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/mholt/caddy-l4@v0.0.0-20250530154005-4d3c80e89c5f" ]; # pain the ass to get this fake version based on commit
        hash = "sha256-O2shDuAA4OjUx44uOxMbd5iQUQVl6GUuFKqv+P/PXNM=";
      };

      virtualHosts = {
        "${domain}".extraConfig = ''
          respond "Hello World"      
        '';
      }
      // builtins.listToAttrs (map makeReverseProxyTcp tcpProxies)
      // builtins.listToAttrs (map makeReverseProxyHttps httpsProxies);

    };

    networking.firewall.allowedTCPPorts = lib.unique (
      [
        80
        443
      ]
      ++ tcpPorts
    );
  };
}
