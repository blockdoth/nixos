{ config, lib, ... }:
let
  module = config.system-modules.core.networking;
  impermanence = config.system-modules.core.impermanence;
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
      interfaces = lib.mkIf module.wakeOnLan {
        enp7s0.wakeOnLan.enable = true;
      };
    };

    services.resolved.enable = true;

    environment.persistence."/persist/backup" = lib.mkIf impermanence.enable {
      directories = [ "/etc/NetworkManager/system-connections" ];
    };

    networking.hosts = lib.mkIf zen.enable {
      "127.0.0.1" = [

        "youtube.com"
        "www.youtube.com"
        "m.youtube.com"
        "youtu.be"

        # "reddit.com"
        "www.reddit.com"
        "old.reddit.com"
        "new.reddit.com"

        "twitter.com"
        "www.twitter.com"
        "x.com"
        "www.x.com"
      ];
    };

  };
}
