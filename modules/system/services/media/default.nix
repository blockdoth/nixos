{
  config,
  lib,
  pkgs,
  ...
}:
let
  domain = config.system-modules.services.domains.homelab;
  module = config.system-modules.presets.mediaserver;
  cfg = config.system-modules.services.media;
  enableMediaServer = cfg.enable;
  mediaDir = cfg.mediaDir;
  mediaGroup = cfg.group;
in
{
  imports = [
    ./audiobookshelf.nix
    ./jellyfin.nix
    ./jellyseerr.nix
    ./prowlarr.nix
    ./radarr.nix
    ./lidarr.nix
    ./sonarr.nix
    ./transmission.nix
    ./bazarr.nix
  ];

  config = lib.mkIf module.enable {
    systemd.tmpfiles.rules = [
      "d ${mediaDir} 0775 root ${mediaGroup} -"
      "d ${mediaDir}/library/movies 0775 root ${mediaGroup} -"
      "d ${mediaDir}/library/series 0775 root ${mediaGroup} -"
      "d ${mediaDir}/library/tv 0775 root ${mediaGroup} -"
      "d ${mediaDir}/library/audiobooks 0775 root ${mediaGroup} -"
      "d ${mediaDir}/library/music 0775 root ${mediaGroup} -"
    ];

    users.groups = {
      ${mediaGroup} = {
        members = [
          "radarr"
          "sonarr"
          "bazarr"
          "prowlarr"
          "jellyfin"
          "jellyseerr"
          "penger"
          "blockdoth"
        ];
      };
    };
  };
}
