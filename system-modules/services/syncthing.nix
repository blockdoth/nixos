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
        enable = true;
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          options = {
            urAccepted = -1;
            relaysEnabled = false;
          };
          guiAddress = "127.0.0.1:8384"; # Web UI address
          insecureSkipHostcheck = true;
          guiTheme = "default"; # Default theme

          devices = {
            "nuc" = {
              id = "";
            };
            "laptop" = {
              id = "";
            };
            "desktop" = {
              id = "";
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
          reverse_proxy ${config.services.syncthing.settings.guiAddress}
        '';
      };
    };
}
