{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.jellyfin.enable = lib.mkEnableOption "Enables jellyfin";
  };

  config = lib.mkIf config.system-modules.services.jellyfin.enable {
    services.jellyfin = {
      enable = true;
      group = mediaGroup;
      listenPort = 6767;
      jellyseerr.enable = true;
    };
    systemd.tmpfiles.rules = [
      "d ${mediaDir}/library/Movies 0775 ${streamerUser} ${mediaGroup} -"
      "d ${mediaDir}/library/TV 0775 ${streamerUser} ${mediaGroup} -"
      "d ${mediaDir}/library/Audiobooks 0775 ${streamerUser} ${mediaGroup} -"
    ];

  };
}
