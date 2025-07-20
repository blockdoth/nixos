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

    system-modules.services = {
      network.caddy.reverse-proxies = [
        {
          subdomain = "chatger";
          port = 4348;
        }
      ];
    };
  };
}
