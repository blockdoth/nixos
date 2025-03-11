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
        respond "Hello World"
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
