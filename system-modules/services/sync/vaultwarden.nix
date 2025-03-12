{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.sync.vaultwarden;
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
        SIGNUPS_ALLOWED = true;
      };
    };

    services.caddy = {
      virtualHosts."vaultwarden.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:${builtins.toString config.services.vaultwarden.config.ROCKET_PORT}
      '';
    };
  };
}
