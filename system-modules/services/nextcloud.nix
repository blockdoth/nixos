{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.nextcloud.enable = lib.mkEnableOption "Enables nextcloud";
  };

  config =
    let
      domain = config.system-modules.services.domains.homelab;
    in
    lib.mkIf config.system-modules.services.nextcloud.enable {
      services.nextcloud = {
        enable = true;
      };

      services.caddy = {
        virtualHosts."nextcloud.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString config.services.minecraft-servers.servers.minecraft_21.serverProperties.server-port}        
        '';
      };
    };
}
