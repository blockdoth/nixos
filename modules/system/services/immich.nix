{
  config,
  lib,
  ...
}:
let
  module = config.system-modules.services.immich;
  domain = config.system-modules.secrets.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.immich = {
      enable = true;
      port = 2283;
      host = "127.0.0.1";
      environment = {
        IMMICH_TELEMETRY_INCLUDE = "all";
      };
    };

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "immich";
          port = config.services.immich.port;
        }
      ];
      observability.healthchecks.endpoints = [
        {
          name = "Immich";
          url = "https://immich.${domain}";
        }
      ];
    };

  };
}
