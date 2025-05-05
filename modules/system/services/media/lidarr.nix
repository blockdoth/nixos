{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  domain = config.system-modules.services.network.domains.homelab;
  cfg = config.system-modules.services.media;
  module = cfg.lidarr;
  mediaDir = cfg.mediaDir;
  mediaGroup = cfg.group;
  impermanence = config.system-modules.core.impermanence;
in
{
  config = lib.mkIf module.enable {
    # Uses port 8686
    services.lidarr = {
      enable = true;
      group = mediaGroup;
    };

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents/lidarr 0775 root ${mediaGroup} -"
    ];

    system-modules.services = {
      network.caddy.reverse-proxies = [
        {
          subdomain = "lidarr";
          port = 8686;
          require-auth = true;
        }
      ];

      observability.gatus.endpoints = [
        {
          name = "Lidarr";
          url = "https://lidarr.${domain}";
          endpoint = "/api/v1/health";
        }
      ];
    };

    environment.persistence."/persist/backup" = lib.mkIf impermanence.enable {
      directories = [
        {
          directory = "/var/lib/lidarr";
          user = "lidarr";
          group = mediaGroup;
          mode = "0755";
        }
      ];
    };
  };
}
