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
  };
}
