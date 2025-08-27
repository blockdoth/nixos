{
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.observability.gatus;
  domain = config.system-modules.secrets.domains.homelab;
  buildUrl = map (
    ep:
    ep
    // {
      url = ep.url + ep.endpoint;
    }
  );
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
        endpoints = buildUrl config.system-modules.services.observability.healthchecks.endpoints;
      };
    };

    system-modules.services.network.reverse-proxy.proxies = [
      {
        subdomain = "gatus";
        port = config.services.gatus.settings.web.port;
        require-auth = true;
      }
    ];
  };
}
