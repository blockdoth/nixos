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
  module = config.system-modules.services.media.radarr;
in
{
  config = lib.mkIf module.enable {
    # Uses port 7878
    services.radarr = {
      enable = true;
      group = mediaGroup;
    };

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents/radarr 0775 ${torrentUser} ${mediaGroup} -"
    ];

    environment.persistence."/persist/backup" = {
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
