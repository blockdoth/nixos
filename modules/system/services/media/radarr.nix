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
  module = cfg.radarr;
  mediaDir = cfg.mediaDir;
  mediaGroup = cfg.group;
  impermanence = config.system-modules.core.impermanence;
in
{
  config = lib.mkIf module.enable {
    # Uses port 7878
    services.radarr = {
      enable = true;
      group = mediaGroup;
    };

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents/radarr 0775 root ${mediaGroup} -"
    ];

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "Radarr";
          port = 7878;
          require-auth = true;
        }
      ];
      observability.healthchecks.endpoints = [
        {
          name = "Radarr";
          url = "https://radarr.${domain}";
          endpoint = "/ping";
        }
      ];
    };

    environment.persistence."/persist/backup" = lib.mkIf impermanence.enable {
      directories = [
        {
          directory = "/var/lib/radarr";
          user = "radarr";
          group = mediaGroup;
          mode = "0755";
        }
      ];
    };
  };
}
