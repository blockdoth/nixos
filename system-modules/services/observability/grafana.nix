{
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.observability.grafana;
  domain = config.system-modules.services.domains.network.iss-piss-stream;
in
{
  # cool snippet for the full stack
  # https://gist.github.com/rickhull/895b0cb38fdd537c1078a858cf15d63e
  config = lib.mkIf module.enable {
    sops.secrets.grafana-password = {
      owner = "grafana";
    };

    services.grafana = {
      enable = true;
      settings = {
        security = {
          admin_user = "blockdoth";
          admin_password = "$__file{${config.sops.secrets.grafana-password.path}}";
        };
        analytics.reporting_enabled = false;
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
        };
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            editable = false;
            url = "http://127.0.0.1:${builtins.toString config.services.prometheus.port}";
          }
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            editable = false;
            url = "http://127.0.0.1:3100";
          }
        ];
      };
    };

    services.caddy = {
      virtualHosts."grafana.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:${builtins.toString config.services.grafana.settings.server.http_port}        
      '';
    };
  };
}
