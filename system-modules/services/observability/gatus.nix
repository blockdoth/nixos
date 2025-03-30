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
        endpoints = config.system-modules.services.observability.gatus.endpoints;
      };
    };

    services.caddy.virtualHosts."gatus.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${builtins.toString config.services.gatus.settings.web.port}
    '';
  };
}
