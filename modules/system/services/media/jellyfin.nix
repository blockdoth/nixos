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
  streamUser = cfg.users.streamer;
  module = config.system-modules.services.media.jellyfin;
in
{
  config = lib.mkIf module.enable {
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

    system-modules.services = {
      network.caddy.reverse-proxies = [
        {
          subdomain = "jellyfin";
          port = 8096;
          require-auth = true;
        }
      ];
      observability.gatus.endpoints = [
        {
          name = "Jellyfin";
          url = "https://jellyfin.${domain}";
          endpoint = "/health";
        }
      ];
    };
  };
}
