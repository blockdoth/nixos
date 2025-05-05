{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  domain = config.system-modules.services.network.domains.homelab;
  cfg = config.system-modules.services.media;
  module = cfg.transmission;
  mediaDir = cfg.mediaDir;
  mediaGroup = cfg.group;
in
{
  config = lib.mkIf module.enable {

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents 0775 root ${mediaGroup} -"
      "d ${mediaDir}/torrents/.incomplete 0775 root ${mediaGroup} -"
      "d ${mediaDir}/torrents/.watch 0775 root ${mediaGroup} -"
    ];

    services.transmission = {
      enable = true;
      group = mediaGroup;
      # package = pkgs.transmission_4;
      openRPCPort = true;
      openPeerPorts = true;
      # webHome = pkgs.flood-for-transmission;
      settings = {
        download-dir = "${mediaDir}/torrents";
        incomplete-dir-enabled = true;
        incomplete-dir = "${mediaDir}/torrents/.incomplete";
        watch-dir-enabled = true;
        watch-dir = "${mediaDir}/torrents/.watch";
        rpc-port = 5141;
        rpc-whitelist-enabled = true;
        # rpc-whitelist-enabled = false;
        # rpc-host-whitelist-enabled = false;
        rpc-authentication-required = false;
        blocklist-enabled = true;
        blocklist-url = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz";
        utp-enabled = true;
        encryption = 1;
        port-forwarding-enabled = false;
        download-queue-size = 10;
        cache-size-mb = 50;
        ratio-limit-enabled = true;
      };
    };
    # Always prioritize other services wrt. I/O
    systemd.services.transmission.serviceConfig.IOSchedulingPriority = 7;

    system-modules.services = {
      network.caddy.reverse-proxies = [
        {
          subdomain = "transmission";
          port = config.services.transmission.settings.rpc-port;
          require-auth = true;
        }
      ];

      observability.gatus.endpoints = [
        {
          name = "Transmission";
          url = "https://transmission.${domain}";
        }
      ];
    };
  };
}
