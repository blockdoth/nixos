{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.auth.authelia;
  domain = config.system-modules.services.network.domains.homelab;
  autheliaPort = 9091;
in
{
  config = lib.mkIf module.enable {
    sops.secrets = {
      authelia-jwt = {
        owner = "authelia-main";
      };
      authelia-storage-encryption = {
        owner = "authelia-main";
      };
      lldap-password = {
        owner = "authelia-main";
      };
    };

    services.authelia.instances.main = {
      enable = true;
      secrets = {
        jwtSecretFile = config.sops.secrets.authelia-jwt.path;
        storageEncryptionKeyFile = config.sops.secrets.authelia-storage-encryption.path;
      };
      environmentVariables = {
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = config.sops.secrets.lldap-password.path;
      };

      settings = {
        session = {
          cookies = [
            {
              authelia_url = "https://auth.${domain}";
            }
          ];
        };
        server = {
          address = "tcp:127.0.0.1:${builtins.toString autheliaPort}";

          # Necessary for Caddy integration
          # See https://www.authelia.com/integration/proxies/caddy/#implementation
          endpoints.authz.forward-auth.implementation = "ForwardAuth";
        };

        logs.level = "info";

        regulation = {
          max_retries = 3;
          find_time = 120;
          ban_time = 300;
        };

        access_control = {
          default_policy = "one_factor";
        };

        identity_providers.oidc.clients = [ ];

        authentication_backend = {
          password_reset.disable = false;
          refresh_interval = "1m";
          ldap = {
            implementation = "custom";
            address = "ldap://127.0.0.1:${builtins.toString config.services.lldap.settings.ldap_port}";
          };
        };
      };
    };

    services.caddy.virtualHosts."authelia.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${builtins.toString autheliaPort}        
    '';

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Authelia";
        url = "https://authelia.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
