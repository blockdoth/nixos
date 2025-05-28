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
          enabled = false;
        };
        "auth" = {
          disable_login_form = false;
        };
        "auth.anonymous" = {
          enabled = true;
        };
        "auth.proxy" = {
          enabled = true;
          header_name = "X-Forwarded-User";
          header_property = "username";
          auto_sign_up = true;
          # Optional: auto-assign roles based on headers or fallback role
          role_attribute_path = "contains(headers['X-Forwarded-Groups'], 'grafana-admins') && 'Admin' || 'Viewer'";
          sync_ttl = 60;
        };
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

    system-modules.services = {
      network.caddy.reverse-proxies = [
        {
          subdomain = "grafana";
          port = config.services.grafana.settings.server.http_port;
          require-auth = true;
          extra-config = ''
            header_up X-Forwarded-User {http.auth.user}
            header_up X-Forwarded-Groups {http.auth.groups}            
          '';
        }
      ];
      observability.gatus.endpoints = [
        {
          name = "Grafana";
          url = "https://grafana.${domain}";
        }
      ];
    };
  };
}
