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
  makeReverseProxy = reverse-proxy: {
    name = "${reverse-proxy.subdomain}.${domain}";
    value.extraConfig = ''
      ${
        if reverse-proxy.require-auth then
          ''
            forward_auth 127.0.0.1:${builtins.toString config.system-modules.services.auth.authelia.port} {
              uri /api/authz/forward-auth
              copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
            }
          ''
        else
          ""
      }
      reverse_proxy ${reverse-proxy.redirect-address}:${builtins.toString reverse-proxy.port} {
        ${reverse-proxy.extra-config}
      }
    '';
  };
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

      virtualHosts = {
        "${domain}".extraConfig = ''
          respond "Hello World"      
        '';
      }
      // builtins.listToAttrs (map makeReverseProxy module.reverse-proxies);
    };

    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
    };
  };
}
