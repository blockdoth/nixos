{
  config,
  lib,
  ...
}:
let
  domain = config.system-modules.secrets.domains.homelab;
  cfg = config.system-modules.services.media;
  module = cfg.bazarr;
  mediaDir = cfg.mediaDir;
  mediaGroup = cfg.group;
  impermanence = config.system-modules.core.impermanence;
in
{
  config = lib.mkIf module.enable {
    services.bazarr = {
      enable = true;
      group = mediaGroup;
      listenPort = 6767;
    };

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents/bazarr 0775 root ${mediaGroup} -"
    ];

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "bazarr";
          port = config.services.bazarr.listenPort;
          require-auth = true;
        }
      ];
      observability.healthchecks.endpoints = [
        {
          name = "Bazarr";
          url = "https://bazarr.${domain}";
        }
      ];
    };
    environment.persistence."/persist/backup" = lib.mkIf impermanence.enable {
      directories = [
        {
          directory = "/var/lib/bazarr";
          user = "bazarr";
          group = mediaGroup;
          mode = "0755";
        }
      ];
    };
  };
}
