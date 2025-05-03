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
  streamerUser = cfg.users.streamer;
  module = config.system-modules.services.media.prowlarr;
  impermanence = config.system-modules.core.impermanence;
in
{
  config = lib.mkIf module.enable {
    # uses port 9696
    services.prowlarr = {
      enable = true;
      # group = mediaGroup;
    };

    environment.persistence."/persist/backup" = lib.mkIf impermanence.enable {
      directories = [
        {
          directory = "/var/lib/private/prowlarr";
          user = "prowlarr";
          group = "prowlarr";
          mode = "0755";
        }
      ];
    };
  };
}
