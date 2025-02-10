{
  config,
  lib,
  pkgs,
  ...
}:
let
  domain = config.system-modules.services.domains.homelab;
  cfg = config.system-modules.services.mediaserver;
  mediaDir = cfg.dataDir;
  mediaGroup = cfg.group;
  enableMediaServer = cfg.enable;
  torrentUser = cfg.users.torrenter;
  streamUser = cfg.users.streamer;
in
{
  # This module is heavily inspired by https://github.com/zmitchell/nixos-configs/blob/main/modules/media_server.nix
  options = {
    system-modules = {
      services.mediaserver = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        dataDir = lib.mkOption {
          type = lib.types.str;
          default = "/var/lib/media";
          description = "Directory for media storage";
        };

        group = lib.mkOption {
          type = lib.types.str;
          default = "media";
          description = "Group for media access";
        };
        users = {
          torrenter = lib.mkOption {
            type = lib.types.str;
            default = "torrenter";
            description = "User for torrent services";
          };
          streamer = lib.mkOption {
            type = lib.types.str;
            default = "streamer";
            description = "User for streaming services";
          };
        };
      };
    };
  };

  imports = [
    ./jellyfin.nix
    ./prowlarr.nix
    ./radarr.nix
    ./lidarr.nix
    ./sonarr.nix
    ./transmission.nix
    ./bazarr.nix
  ];

  config = {
    system-modules = {
      services = {
        bazarr.enable = lib.mkDefault enableMediaServer;
        jellyfin.enable = lib.mkDefault enableMediaServer;
        prowlarr.enable = lib.mkDefault enableMediaServer;
        radarr.enable = lib.mkDefault enableMediaServer;
        lidarr.enable = lib.mkDefault enableMediaServer;
        sonarr.enable = lib.mkDefault enableMediaServer;
        transmission.enable = lib.mkDefault enableMediaServer;
      };
    };

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
