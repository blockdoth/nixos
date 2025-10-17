{
  config,
  lib,
  ...
}:
let
  domain = config.system-modules.secrets.domains.homelab;
  cfg = config.system-modules.services.media;
  module = cfg.jellyseerr;
in
{
  config = lib.mkIf module.enable {
    services.jellyseerr = {
      enable = true;
      port = 5055;
    };

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "jellyseerr";
          port = config.services.jellyseerr.port;
          require-auth = true;
        }
      ];
      observability.healthchecks.endpoints = [
        {
          name = "Jellyseerr";
          url = "https://jellyseerr.${domain}";
          endpoint = "/api/v1/status";
        }
      ];
    };
  };
}
