{ config, lib, ... }:
let
  module = config.system-modules.core.networking;
  zen = config.system-modules.presets.zenmode;
in
{
  config = lib.mkIf module.enable {
    networking = {
      hostName = module.hostname;
      firewall = {
        enable = true;
      };
      networkmanager = {
        enable = true;
        wifi.scanRandMacAddress = false;
      };
    };

    services.resolved.enable = true;

    networking.hosts = lib.mkMerge [
      {
        "127.0.0.1" = [
          "x.com"
          "www.x.com"
          "server4.beyondallreason.info"
        ];
      }

      (lib.mkIf zen.enable {
        "127.0.0.1" = [
          "youtube.com"
          "www.youtube.com"
          "m.youtube.com"
          "youtu.be"

          "reddit.com"
          "www.reddit.com"
          "old.reddit.com"
          "new.reddit.com"
        ];
      })
    ];
  };
}
