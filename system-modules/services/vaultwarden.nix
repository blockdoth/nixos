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
  gatusIsEnabled = config.system-modules.services.observability.gatus.enable;
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

    services.caddy.virtualHosts."vaultwarden.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}
    '';

    system-modules.services.observability.gatus.endpoints = lib.mkIf gatusIsEnabled [
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
