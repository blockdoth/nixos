{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.immich;
  domain = config.system-modules.services.network.domains.homelab;
  gatusIsEnabled = config.system-modules.services.observability.gatus.enable;
in
{
  config = lib.mkIf module.enable {
    services.immich = {
      enable = true;
      port = 2283;
      host = "127.0.0.1";
    };

    services.caddy.virtualHosts."immich.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.immich.port}        
    '';

    system-modules.services.observability.gatus.endpoints = lib.mkIf gatusIsEnabled [
      {
        name = "Immich";
        url = "https://immich.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
