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
  mediaDir = cfg.mediaDir;
  mediaGroup = cfg.mediaGroup;
  streamUser = cfg.users.streamer;
  module = config.system-modules.services.media.jellyseer;
in
{
  config = lib.mkIf module.enable {
    services.jellyseer = {
      enable = true;
      port = 5055;
    };

    system-modules.services.network.caddy.reverse-proxies = [
      {
        subdomain = "jellyseer";
        port = config.services.jellyseer.port;
        require-auth = true;
      }
    ];

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Jellyseer";
        url = "https://jellyseer.${domain}/api/v1/status";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
