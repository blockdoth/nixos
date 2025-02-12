{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.immich.enable = lib.mkEnableOption "Enables immich";
  };

  config =
    let
      domain = config.system-modules.services.domains.homelab;
    in
    lib.mkIf config.system-modules.services.immich.enable {
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
