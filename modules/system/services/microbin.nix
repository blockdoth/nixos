{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.microbin;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.microbin = {
      enable = true;
      settings = {
        MICROBIN_WIDE = true;
        MICROBIN_MAX_FILE_SIZE_UNENCRYPTED_MB = 2048;
        MICROBIN_PUBLIC_PATH = "https://microbin.${domain}";
        MICROBIN_BIND = "127.0.0.1";
        MICROBIN_PORT = 8069;
        MICROBIN_HIDE_LOGO = true;
        MICROBIN_HIGHLIGHTSYNTAX = true;
        MICROBIN_HIDE_FOOTER = true;
        MICROBIN_QR = true;
        MICROBIN_DISABLE_TELEMETRY = true;
      };
    };

    services.caddy.virtualHosts."microbin.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.anki-sync-server.port}
    '';

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Microbin";
        url = "https://microbin.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
