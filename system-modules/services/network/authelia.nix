{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.network.acme;
  domain = config.system-modules.services.network.domains.homelab;
  autheliaPort = 9091;
in
{
  config = lib.mkIf module.enable {
    services.authelia.instances.main = {
      enable = true;
      settings = {
        server.address = "http://127.0.0.1:${autheliaPort}";
      };
    };

    services.caddy = {
      virtualHosts."authelia.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:${builtins.toString autheliaPort}        
      '';
    };
  };
}
