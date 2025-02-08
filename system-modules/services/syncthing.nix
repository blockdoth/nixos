{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.syncthing.enable = lib.mkEnableOption "Enables syncthing";
  };

  config =
    let
      domain = config.system-modules.services.domains.homelab;
    in
    lib.mkIf config.system-modules.services.syncthing.enable {
      services.syncthing = {
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          devices = {
            "nuc" = {
              id = "DEVICE-ID-GOES-HERE";
            };
            "laptop" = {
              id = "DEVICE-ID-GOES-HERE";
            };
            "desktop" = {
              id = "DEVICE-ID-GOES-HERE";
            };
          };

          folders = {
            "Documents" = {
              path = "~/Documents";
              devices = [
                "laptop"
                "desktop"
                "nuc"
              ];
            };
            "Pictures" = {
              path = "~/Pictures";
              devices = [
                "laptop"
                "desktop"
                "nuc"
              ];
            };
            "Videos" = {
              path = "~/Videos";
              devices = [
                "laptop"
                "desktop"
                "nuc"
              ];
            };
          };
        };
      };

      # Disables a default sync folder from being created
      systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

      services.caddy = {
        virtualHosts."syncthing.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString config.services.minecraft-servers.servers.minecraft_21.serverProperties.server-port}        
        '';
      };
    };
}
