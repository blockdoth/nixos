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

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "atuin";
          port = config.services.atuin.port;
        }
      ];
      observability.healthchecks.endpoints = [
        {
          name = "Atuin";
          url = "https://atuin.${domain}";
        }
      ];
    };
  };
}
