{
  config,
  lib,
  ...
}:
let
  domain = config.system-modules.secrets.domains.homelab;
  cfg = config.system-modules.services.media;
  module = cfg.lidarr;
  mediaDir = cfg.mediaDir;
  mediaGroup = cfg.group;
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
      network.reverse-proxy.proxies = [
        {
          subdomain = "lidarr";
          port = 8686;
          require-auth = true;
        }
      ];

      observability.healthchecks.endpoints = [
        {
          name = "Lidarr";
          url = "https://lidarr.${domain}";
          endpoint = "/api/v1/health";
        }
      ];
    };

  };
}
