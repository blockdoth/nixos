{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.chatger;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {

    systemd.services.chatger = {
      description = "Chatger Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "/home/penger/sources/chatger/chatger";
        WorkingDirectory = "/home/penger/sources";
        Restart = "on-failure";
        User = "penger";
        Group = "penger";
      };
    };

    system-modules.services = {
      network.caddy.reverse-proxies = [
        {
          subdomain = "chatger";
          type = "tcp";
          port = 4348;
        }
      ];
    };
  };
}
