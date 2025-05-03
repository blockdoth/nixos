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
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      caddy
    ];

    services.caddy = {
      enable = true;
      email = "pepijn.pve@gmail.com";

      virtualHosts."${domain}".extraConfig = ''
        route {
          # Exclude the authelia public paths like the login
          handle_path /authelia* {
            reverse_proxy http://127.0.0.1:9091
          }

          # Protect all routes behind Authelia
          handle {
            forward_auth {
              uri /api/verify?rd=https://{host}{uri}
              address http://127.0.0.1:9091
              copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }

            reverse_proxy http://127.0.0.1:7070
          }
        }
      '';
    };

    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
    };
    users.users.caddy.extraGroups = [ "acme" ];
  };
}
