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
  mediaDir = cfg.dataDir;
  mediaGroup = cfg.group;
  torrentUser = cfg.users.torrenter;
  module = config.system-modules.services.media.bazarr;
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
      "d ${mediaDir}/torrents/bazarr 0775 ${torrentUser} ${mediaGroup} -"
    ];

    system-modules.services = {
      network.caddy.reverse-proxies = [
        {
          subdomain = "bazarr";
          port = config.services.bazarr.listenPort;
          require-auth = true;
        }
      ];
      observability.gatus.endpoints = [
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
