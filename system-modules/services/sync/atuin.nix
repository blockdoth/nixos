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

    services.caddy.virtualHosts."atuin.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.atuin.port}
    '';

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Atuin";
        url = "https://www.atuin.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
