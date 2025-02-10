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
  streamUser = cfg.users.streamer;
in
{
  options = {
    system-modules.services.jellyfin.enable = lib.mkEnableOption "Enables jellyfin";
  };

  config = lib.mkIf config.system-modules.services.jellyfin.enable {
    # Uses port 8096
    services.jellyfin = {
      enable = true;
      group = mediaGroup;
    };

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/library/Movies 0775 ${streamUser} ${mediaGroup} -"
      "d ${mediaDir}/library/TV 0775 ${streamUser} ${mediaGroup} -"
      "d ${mediaDir}/library/Audiobooks 0775 ${streamUser} ${mediaGroup} -"
    ];
  };
}
