{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
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
