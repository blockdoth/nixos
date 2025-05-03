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
  impermanence = config.system-modules.core.impermanence;
in
{
  config = lib.mkIf module.enable {
    services.immich = {
      enable = true;
      port = 2283;
      host = "127.0.0.1";
    };

    system-modules.services.network.caddy.reverse-proxies = [
      {
        subdomain = "immich";
        port = config.services.immich.port;
      }
    ];

    system-modules.services.observability.gatus.endpoints = [
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

    environment.persistence."/persist/backup".directories = lib.mkIf impermanence.enable [
      {
        directory = config.services.immich.mediaLocation;
        user = "immich";
        group = "immich";
        mode = "0750";
      }
    ];
  };
}
