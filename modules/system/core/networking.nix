{ config, lib, ... }:
let
  module = config.system-modules.core.networking;
  impermanence = config.system-modules.core.impermanence;

  blockedDomains = [
    "instagram.com"
    "twitter.com"
    "tiktok.com"
    "x.com"
    "reddit.com"
    "linkedin.com"
    "youtube.com"
    "whatsapp.com"
    "discord.com"
  ];
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

    services.dnsmasq = lib.mkIf module.blocking.enable {
      enable = true;

      settings = {
        listen-address = "127.0.0.1";

        address = map (d: "/${d}/0.0.0.0") blockedDomains;
      };
    };

    # firewall rules restricting DNS for clausum
    networking.firewall.extraCommands = lib.mkIf module.blocking.enable ''
      UID=$(id -u ${module.blocking.user})

      # allow user to query local dnsmasq
      iptables -A OUTPUT -m owner --uid-owner $UID -p udp --dport 53 -d 127.0.0.1 -j ACCEPT
      iptables -A OUTPUT -m owner --uid-owner $UID -p tcp --dport 53 -d 127.0.0.1 -j ACCEPT

      # block all other DNS
      iptables -A OUTPUT -m owner --uid-owner $UID -p udp --dport 53 -j REJECT
      iptables -A OUTPUT -m owner --uid-owner $UID -p tcp --dport 53 -j REJECT
    '';

    networking.firewall.extraStopCommands = lib.mkIf module.blocking.enable ''
      UID=$(id -u ${module.blocking.user})

      iptables -D OUTPUT -m owner --uid-owner $UID -p udp --dport 53 -d 127.0.0.1 -j ACCEPT || true
      iptables -D OUTPUT -m owner --uid-owner $UID -p tcp --dport 53 -d 127.0.0.1 -j ACCEPT || true
      iptables -D OUTPUT -m owner --uid-owner $UID -p udp --dport 53 -j REJECT || true
      iptables -D OUTPUT -m owner --uid-owner $UID -p tcp --dport 53 -j REJECT || true
    '';

  };
}
