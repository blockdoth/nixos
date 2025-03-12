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
  config = {
    services.vaultwarden = {
      enable = true;
      dbBackend = "postgresql";
    };

    services.caddy = {
      virtualHosts."vaultwarden.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.atuin.port}
      '';
    };
  };
}
