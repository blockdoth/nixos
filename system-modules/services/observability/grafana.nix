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
  config =
    let
      domain = config.system-modules.services.domains.iss-piss-stream;
    in
    lib.mkIf config.system-modules.services.grafana.enable {
      services.grafana = {
        enable = true;
        settings = {
          security = {
            admin_user = "user";
            admin_password = "$__file{${config.sops.secrets.grafana-password.path}}";
          };
          analytics.reporting_enabled = false;
          server = {
            http_addr = "localhost";
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
              url = "http://localhost:${builtins.toString config.services.prometheus.port}";
            }
          ];
        };
      };

      services.caddy = {
        virtualHosts."grafana.${domain}".extraConfig = ''
          reverse_proxy http://localhost:${builtins.toString config.services.grafana.settings.server.http_port}        
        '';
      };
    };
}
