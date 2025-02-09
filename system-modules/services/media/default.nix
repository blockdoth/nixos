{
  config,
  lib,
  pkgs,
  ...
}:
let
  mediaDir = "/var/lib/media";
  mediaGroup = "media";
  domain = config.system-modules.services.domains.homelab;
  enableMediaServer = config.system-modules.mediaserver.enable;
  torrentUser = "torrenter";
  streamerUser = "streamer";
in
{
  # This module is heavily inspired by https://github.com/zmitchell/nixos-configs/blob/main/modules/media_server.nix

  options = {
    system-modules = {
      mediaserver.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  imports = [
    ./jellyfin.nix
    ./prowler.nix
    ./radarr.nix
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
        group = "streamer";
      };
      torrenter = {
        isSystemUser = true;
        group = torrentUser;
      };
    };

  };
}
