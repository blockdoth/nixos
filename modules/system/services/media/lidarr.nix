{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  domain = config.system-modules.services.network.domains.homelab;
  cfg = config.system-modules.services.mediaserver;
  mediaDir = cfg.dataDir;
  mediaGroup = cfg.group;
  torrentUser = cfg.users.torrenter;
  module = config.system-modules.services.media.lidarr;
  impermanence = config.system-modules.core.impermanence;
in
{
  config = lib.mkIf module.enable {
    # Uses port 7878
    services.lidarr = {
      enable = true;
      group = mediaGroup;
    };

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents/lidarr 0775 ${torrentUser} ${mediaGroup} -"
    ];

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
