{
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.grafana.enable = lib.mkEnableOption "Enables grafana";
  };
  # cool snippet for the full stack
  # https://gist.github.com/rickhull/895b0cb38fdd537c1078a858cf15d63e
  config = lib.mkIf config.system-modules.services.grafana.enable {
    services.grafana = {
      enable = true;
      settings = {
        analytics.reporting_enabled = false;
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
        };
      };
      # security = {
      #   admin_user = "";
      #   admin_password = "";
      # };
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
        ];
      };
    };
  };
}