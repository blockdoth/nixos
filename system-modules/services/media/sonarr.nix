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
    system-modules.services.sonarr.enable = lib.mkEnableOption "Enables sonarr";
  };

  config = lib.mkIf config.system-modules.services.sonarr.enable {
    # Uses port 8989
    services.sonarr = {
      enable = true;
      group = mediaGroup;
    };

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents/sonarr 0775 ${torrentUser} ${mediaGroup} -"
    ];
  };
}
