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
  impermanence = config.system-modules.core.impermanence;
in
{
  config = lib.mkIf module.enable {
    services.microbin = {
      enable = true;
      settings = {
        MICROBIN_PUBLIC_PATH = "https://microbin.${domain}";
        MICROBIN_BIND = "127.0.0.1";
        MICROBIN_PORT = 8069;
        MICROBIN_HIDE_LOGO = true;
        MICROBIN_HIGHLIGHTSYNTAX = true;
        MICROBIN_HIDE_FOOTER = true;
        MICROBIN_QR = true;
        MICROBIN_DISABLE_TELEMETRY = true;
        # MICROBIN_ENABLE_BURN_AFTER = true;
        # MICROBIN_EDITABLE = true;
      };
    };

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "microbin";
          port = config.services.microbin.settings.MICROBIN_PORT;
        }
      ];
      observability.healthchecks.endpoints = [
        {
          name = "Microbin";
          url = "https://microbin.${domain}";
        }
      ];
    };

    environment.persistence."/persist/backup" = lib.mkIf impermanence.enable {
      directories = [
        {
          directory = "/var/lib/private/microbin";
          mode = "0700";
          user = "microbin";
          group = "microbin";
        }
      ];
    };
  };
}
