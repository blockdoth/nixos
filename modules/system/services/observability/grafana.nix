{
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.observability.grafana;
  domain = config.system-modules.services.network.domains.iss-piss-stream;
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
        "auth.basic" = {
          enabled = true;
        };
        "auth.anonymous" = {
          enabled = true;
        };
        "auth.proxy" = {
          enabled = true;
          header_name = "Remote-User";
          header_property = "username";
          auto_sign_up = true;
          role_attribute_path = "'Admin'";
        };
        security = {
          admin_user = "admin";
          admin_password = "admin";
          # admin_password = "$__file{${config.sops.secrets.grafana-password.path}}";
          disable_brute_force_login_protection = true;
          disable_initial_admin_creation = false;
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

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "grafana";
          port = config.services.grafana.settings.server.http_port;
          require-auth = true;
          extra-config = ''
            header_up X-Forwarded-User {http.auth.user.id}
            header_up X-Forwarded-Groups {http.auth.user.groups}
            header_up X-Forwarded-Email {http.auth.user.email}     
          '';
        }
      ];
      observability.healthchecks.endpoints = [
        {
          name = "Grafana";
          url = "https://grafana.${domain}";
        }
      ];
    };
  };
}
