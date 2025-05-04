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
  ssoPluginManifest = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/9p4/jellyfin-plugin-sso/manifest-release/manifest.json";
    sha256 = "sha256-MpHfZy+vGo3gBEF+gJ+7Vzl4MIXKxUHn4uP4GDr2heA=";
  };
in
{
  config = lib.mkIf module.enable {
    # Uses port 8096
    services.jellyfin = {
      enable = true;
      group = mediaGroup;
    };

    environment.etc = {
      "jellyfin/plugins/sso".source = ssoPluginManifest;
    };

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/library/Movies 0775 ${streamUser} ${mediaGroup} -"
      "d ${mediaDir}/library/TV 0775 ${streamUser} ${mediaGroup} -"
      "d ${mediaDir}/library/Audiobooks 0775 ${streamUser} ${mediaGroup} -"
    ];

    system-modules.services.network.caddy.reverse-proxies = [
      {
        subdomain = "jellyfin";
        port = 8096;
        require-auth = true;
      }
    ];

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Jellyfin";
        url = "https://jellyfin.${domain}/health";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
