{
  config,
  lib,
  ...
}:
let
  module = config.system-modules.core.syncthing;
  enableGui = config.system-modules.presets.gui.enable;
in
{
  # TODO move to core
  config = lib.mkIf module.enable {

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
            id = "UXUGHM7-CIWOOSK-645WLMP-H3OWM55-FV7DQPE-AVQQETY-RM62HNU-RSJNHAN";
          };
          "desktop" = {
            id = "AVQCDW7-5V6CHQF-XSNYXSP-5MOO62T-VX5N5RJ-GPMREGK-IQ6YSKA-IPI4UQ6";
          };
          "phone" = {
            id = "T7OIBFT-YRPMXDU-RMEWFF3-S2KB5XW-CHH4ENT-RLN3SHQ-MCHKWFB-WYLY6AE";
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
          "phone" = {
            path = "~/share";
            devices = [
              "laptop"
              "desktop"
              "nuc"
              "phone"
            ];
          };
        };
      };
    };

    # Delay syncthing to after boot, to speed up boot
    systemd.services.syncthing-init = {
      wantedBy = lib.mkForce (if enableGui then [ "default.target" ] else [ "multi-user.target" ]);
      after = lib.mkForce ([ "syncthing.service" ] ++ lib.optionals enableGui [ "default.target" ]);
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
  };
}
