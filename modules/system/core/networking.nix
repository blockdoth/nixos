{ config, lib, ... }:
let
  module = config.system-modules.core.networking;
  zenmode = config.system-modules.presets.zenmode;
  hostname = module.hostname;

  blockedDomains = [
    "facebook.com"
    "www.facebook.com"
    "instagram.com"
    "www.instagram.com"
    "twitter.com"
    "www.twitter.com"
    "tiktok.com"
    "www.tiktok.com"
    "reddit.com"
    "www.reddit.com"
    "linkedin.com"
    "www.linkedin.com"
    "youtube.com"
    "www.youtube.com"
    "whatsapp.com"
    "www.whatsapp.com"
    "messenger.com"
    "www.messenger.com"
    "telegram.org"
    "www.telegram.org"
    "discord.com"
    "www.discord.com"
  ];

  blockedHosts = lib.concatStringsSep "\n" (map (domain: "0.0.0.0 ${domain}") blockedDomains);
  impermanence = config.system-modules.core.impermanence;
in
{
  config = lib.mkIf module.enable {
    networking = {
      hostName = hostname;
      firewall = {
        enable = true;
      };
      networkmanager = {
        enable = true;
        wifi.scanRandMacAddress = false;
      };
      interfaces = {
        eno1.wakeOnLan.enable = module.wakeOnLan;
        enp7s0.wakeOnLan.enable = module.wakeOnLan;
      };
      # Block distracting domains in zenmode
      extraHosts = lib.mkIf zenmode.enable blockedHosts;
    };

    services.resolved.enable = true;

    environment.persistence."/persist/backup" = lib.mkIf impermanence.enable {
      directories = [ "/etc/NetworkManager/system-connections" ];
    };
  };
}
