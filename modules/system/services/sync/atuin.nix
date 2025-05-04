{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.sync.atuin;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.atuin = {
      enable = true;
      openRegistration = false;
      openFirewall = false;
      port = 8889;
    };

    system-modules.services.network.caddy.reverse-proxies = [
      {
        subdomain = "atuin";
        port = config.services.atuin.port;
      }
    ];

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Atuin";
        url = "https://atuin.${domain}";
      }
    ];
  };
}
