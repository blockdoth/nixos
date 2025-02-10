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
    system-modules.services.bazarr.enable = lib.mkEnableOption "Enables bazarr";
  };

  config = lib.mkIf config.system-modules.services.bazarr.enable {
    services.bazarr = {
      enable = true;
      group = mediaGroup;
      listenPort = 6767;
    };
    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents/bazarr 0775 ${torrentUser} ${mediaGroup} -"
    ];
  };
}
