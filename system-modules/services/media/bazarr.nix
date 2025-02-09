{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
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
