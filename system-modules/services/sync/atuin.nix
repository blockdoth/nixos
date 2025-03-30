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
  gatusIsEnabled = config.system-modules.services.observability.gatus.enable;
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

    system-modules.services.observability.gatus.endpoints = lib.mkIf gatusIsEnabled [
      {
        name = "Atuin";
        url = "https://atuin.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
