{
  config,
  lib,
  pkgs,
  ...
}:
let
  domain = config.system-modules.services.domains.homelab;
  cfg = config.system-modules.presets.mediaserver;
  mediaDir = cfg.dataDir;
  mediaGroup = cfg.group;
  enableMediaServer = cfg.enable;
  torrentUser = cfg.users.torrenter;
  streamUser = cfg.users.streamer;
  module = config.system-modules.presets.mediaserver;
in
{
  imports = [
    ./jellyfin.nix
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
    ];

    users.groups = {
      streamer = { };
      torrenter = { };
      ${mediaGroup} = {
        members = [
          "radarr"
          "sonarr"
          "bazarr"
          "prowlarr"
          "jellyfin"
          "penger"
          "blockdoth"
          torrentUser
        ];
      };
    };

    users.users = {
      streamer = {
        isSystemUser = true;
        group = streamUser;
      };
      torrenter = {
        isSystemUser = true;
        group = torrentUser;
      };
    };
  };
}
