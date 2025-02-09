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
      environment.systemPackages = with pkgs; [
        syncthing
      ];
      services.syncthing = {
        enable = true;
        overrideDevices = true;
        overrideFolders = true;
        user = if (config.system-modules.users.blockdoth.enable) then "blockdoth" else "penger";
        dataDir =
          if (config.system-modules.users.blockdoth.enable) then "/home/blockdoth" else "/home/penger";
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
              id = "4XXGJ3J-4GTASWI-FH7NAJA-6QY5THZ-CUIJ7VP-SC7RTF7-WKFJMWR-YAR4JQD";
            };
            "laptop" = {
              id = "IWF7EVG-S65KQ4N-OD4O2UX-WQSOKGQ-F4JUEJA-YRCFXG2-OMMVPXI-GNVZUQH";
            };
            "desktop" = {
              id = "AVQCDW7-5V6CHQF-XSNYXSP-5MOO62T-VX5N5RJ-GPMREGK-IQ6YSKA-IPI4UQ6";
            };
          };

          folders = {
            "documents" = {
              path = "~/documents";
              devices = [
                "laptop"
                "desktop"
                "nuc"
              ];
            };
            "pictures" = {
              path = "~/pictures";
              devices = [
                "laptop"
                "desktop"
                "nuc"
              ];
            };
            "videos" = {
              path = "~/videos";
              devices = [
                "laptop"
                "desktop"
                "nuc"
              ];
            };
            "music" = {
              path = "~/music";
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
