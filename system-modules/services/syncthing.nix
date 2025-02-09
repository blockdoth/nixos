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
      domain = config.system-modules.domains.homelab;
    in
    lib.mkIf config.system-modules.services.syncthing.enable {
      environment.systemPackages = with pkgs; [
        syncthing
      ];
      services.syncthing = {
        enable = true;
        overrideDevices = true;
        overrideFolders = true;
        settings = {
          options = {
            urAccepted = -1;
            relaysEnabled = false;
          };
          gui = {
            user = "blockdoth";
            tls = true;
            insecureSkipHostcheck = true;
          };
          # guiPasswordFile = config.sops.secrets.acme-cloudflare-api-key.path;
          guiTheme = "dark";

          devices = {
            "nuc" = {
              id = "HPXVJ5B-U4UDXBT-WKV55TS-33KSKDB-4GABRYH-6VDTISA-5DHG5UZ-EXR74AR";
            };
            "laptop" = {
              id = "IWF7EVG-S65KQ4N-OD4O2UX-WQSOKGQ-F4JUEJA-YRCFXG2-OMMVPXI-GNVZUQH";
            };
            "desktop" = {
              id = "FWX7EKE-FKNDAYT-WEL3VEF-AKFXYVN-SQWYSBX-ANVNSHK-VQDCDIH-J2AE6QM";
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

      networking.firewall = {
        allowedTCPPorts = [ 22000 ];
        allowedUDPPorts = [
          21027
          22000
        ];
      };
      # Disables a default sync folder from being created
      systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

      services.caddy = {
        virtualHosts."syncthing.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:8384        
        '';
      };
    };
}
