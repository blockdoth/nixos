{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  domain = config.system-modules.services.domains.homelab;
  cfg = config.system-modules.services.mediaserver;
  mediaDir = cfg.dataDir;
  mediaGroup = cfg.group;
  torrentUser = cfg.users.torrenter;
in
{
  options = {
    system-modules.services.lidarr.enable = lib.mkEnableOption "Enables lidarr";
  };

  config = lib.mkIf config.system-modules.services.lidarr.enable {
    # Uses port 7878
    services.lidarr = {
      enable = true;
      group = mediaGroup;
    };

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents/lidarr 0775 ${torrentUser} ${mediaGroup} -"
    ];
  };
}
