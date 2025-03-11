{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.web.immich;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.immich = {
      enable = true;
      port = 2283;
      host = "127.0.0.1";
    };

    services.caddy = {
      virtualHosts."immich.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.immich.port}        
      '';
    };
  };
}
