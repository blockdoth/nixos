{
  pkgs,
  config,
  lib,
  ...
}:
let
  domain = config.system-modules.secrets.domains.homelab;
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
      webHome = pkgs.flood-for-transmission;
      settings = {
        download-dir = "${mediaDir}/torrents";
        incomplete-dir-enabled = true;
        incomplete-dir = "${mediaDir}/torrents/.incomplete";
        watch-dir-enabled = true;
        watch-dir = "${mediaDir}/torrents/.watch";
        rpc-port = 5141;
        rpc-host-whitelist-enabled = false;
        # rpc-host-whitelist = [ "transmission.${domain}" ];
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
      network.reverse-proxy.proxies = [
        {
          subdomain = "transmission";
          port = config.services.transmission.settings.rpc-port;
          require-auth = true;
          extra-config = ''
            header_up Access-Control-Allow-Origin *
            header_up Access-Control-Allow-Methods "GET, POST, OPTIONS"
            header_up Access-Control-Allow-Headers "X-Transmission-Session-Id, Content-Type"
          '';
        }
      ];

      observability.healthchecks.endpoints = [
        {
          name = "Transmission";
          url = "https://transmission.${domain}";
        }
      ];
    };
  };
}
