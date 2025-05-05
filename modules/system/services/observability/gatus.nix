{
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.observability.gatus;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.gatus = {
      enable = true;
      settings = {
        web.port = 7070;
        alerting = {
          # TODO
        };

        ui = {
          title = "My Gatus Dashboard";
          theme = "dark";
        };
        endpoints = map (
          ep:
          ep
          // {
            url = ep.url + ep.endpoint;
          }
        ) config.system-modules.services.observability.gatus.endpoints;
      };
    };

    system-modules.services.network.caddy.reverse-proxies = [
      {
        subdomain = "gatus";
        port = config.services.gatus.settings.web.port;
        require-auth = true;
      }
    ];
  };
}
