{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.vaultwarden;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {

    # port 8222
    services.vaultwarden = {
      enable = true;
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        DOMAIN = "https://vaultwarden.${domain}";
        SIGNUPS_ALLOWED = false;
      };
    };

    system-modules.services.network.caddy.reverse-proxies = [
      {
        subdomain = "vaultwarden";
        port = config.services.vaultwarden.config.ROCKET_PORT;
      }
    ];

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Vaultwarden";
        url = "https://vaultwarden.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
