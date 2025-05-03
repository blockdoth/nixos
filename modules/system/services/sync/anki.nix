{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.sync.anki;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    sops.secrets.anki-password = { };
    services.anki-sync-server = {
      enable = true;
      address = "127.0.0.1";
      port = 27701;
      users = [
        {
          username = "blockdoth";
          passwordFile = config.sops.secrets.anki-password.path;
        }
      ];
    };

    system-modules.services.network.caddy.reverse-proxies = [
      {
        subdomain = "anki";
        port = config.services.anki-sync-server.port;
      }
    ];

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Anki";
        url = "https://anki.${domain}/health";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
