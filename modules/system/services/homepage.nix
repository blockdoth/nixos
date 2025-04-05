{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.homepage;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.homepage-dashboard = {
      enable = true;
      listenPort = 8082;
      settings = {

      };
    };

    services.caddy.virtualHosts."homepage.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.homepage-dashboard.listenPort}        
    '';

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Homepage";
        url = "https://homepage.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
