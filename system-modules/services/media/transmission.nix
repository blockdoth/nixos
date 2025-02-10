{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  domain = config.system-modules.services.domains.homelab;
  cfg = config.system-modules.services.mediaserver;
  mediaDir = cfg.dataDir;
  mediaGroup = cfg.group;
  enableMediaServer = cfg.enable;
  torrentUser = cfg.users.torrenter;
  streamUser = cfg.users.streamer;
  transmissionPort = cfg.torrentPort;
in
{
  options = {
    system-modules.services.transmission.enable = lib.mkEnableOption "Enables transmission";
  };

  config = lib.mkIf config.system-modules.services.transmission.enable {

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents 0775 ${torrentUser} ${mediaGroup} -"
      "d ${mediaDir}/torrents/.incomplete 0775 ${torrentUser} ${mediaGroup} -"
      "d ${mediaDir}/torrents/.watch 0775 ${torrentUser} ${mediaGroup} -"
    ];

    services.transmission = {
      enable = true;
      user = torrentUser;
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
        rpc-port = transmissionPort;
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
  };
}
