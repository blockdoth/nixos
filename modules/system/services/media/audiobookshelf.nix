{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.media.audiobookshelf;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.audiobookshelf = {
      enable = true;
      port = 8113;

    };

    system-modules.services.network.caddy.reverse-proxies = [
      {
        subdomain = "audiobookshelf";
        port = config.services.audiobookshelf.port;
        require-auth = true;
      }
    ];

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Audiobookshelf";
        url = "https://audiobookshelf.${domain}";
        endpoint = "/healthcheck";
      }
    ];
  };
}
