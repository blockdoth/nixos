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
    system-modules.services.radarr.enable = lib.mkEnableOption "Enables radarr";
  };

  config = lib.mkIf config.system-modules.services.radarr.enable {
    # Uses port 7878
    services.radarr = {
      enable = true;
      group = mediaGroup;
    };

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents/radarr 0775 ${torrentUser} ${mediaGroup} -"
    ];
  };
}
