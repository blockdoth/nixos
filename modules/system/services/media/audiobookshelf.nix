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

    services.caddy.virtualHosts."audiobookshelf.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.audiobookshelf.port}
    '';

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Audiobookshelf";
        url = "https://audiobookshelf.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
