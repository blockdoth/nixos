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
  lldap-config = config.system-modules.services.auth.lldap;
  autheliaPort = 9091;
in
{
  config = lib.mkIf module.enable {
    sops.secrets = {
      authelia-jwt = {
        owner = "authelia-main";
        group = "authelia-main";
      };
      authelia-storage-encryption = {
        owner = "authelia-main";
        group = "authelia-main";
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "authelia-main" ];
      ensureUsers = [
        {
          name = "authelia-main";
          ensureDBOwnership = true;
        }
      ];

      # ensurePrivileges = {
      #   ${autheliaDB} = {
      #     "${autheliaUser}" = "ALL PRIVILEGES";
      #   };
      # };
    };

    systemd.services.authelia-main.serviceConfig.SupplementaryGroups = [ lldap-config.shared-group ];

    services.authelia.instances.main = {
      enable = true;
      secrets = {
        jwtSecretFile = lldap-config.shared-jwt;
        storageEncryptionKeyFile = config.sops.secrets.authelia-storage-encryption.path;
      };
      environmentVariables = {
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = lldap-config.shared-password;
      };

      settings = {
        logs.level = "info";

        authentication_backend.ldap = {
          address = "ldap://127.0.0.1:${builtins.toString config.services.lldap.settings.ldap_port}";
          base_dn = "dc=haddock,dc=cc";
          user = "uid=admin,ou=people,dc=longerhv,dc=xyz";
          users_filter = "(&({username_attribute}={input})(objectClass=person))";
          groups_filter = "(member={dn})";
        };

        access_control = {
          default_policy = "deny";
          rules = [
            {
              domain = [ domain ];
              policy = "one_factor";
            }
          ];
        };

        session = {
          name = "authelia_session";
        };

        server = {
          address = "tcp:127.0.0.1:${builtins.toString autheliaPort}";
          # Necessary for Caddy integration
          # See https://www.authelia.com/integration/proxies/caddy/#implementation
          endpoints.authz.forward-auth.implementation = "ForwardAuth";
        };
        regulation = {
          max_retries = 3;
          find_time = 120;
          ban_time = 300;
        };

        notifier = {
          disable_startup_check = false;
          filesystem = {
            filename = "/var/lib/authelia/notification.txt"; # log path
          };
        };

        storage.local.path = "/var/lib/authelia-main/db.sqlite3";

        identity_providers.oidc = {
          jwk = [ ];
          clients = [
            {
              authorization_policy = "one_factor";
              client_id = "immich";
              client_secret = "";
              redirect_uris = [
                "https://immich.${domain}/auth/login"
                "https://immich.${domain}/user-settings"
                "app.immich:///oauth-callback"
              ];
              scopes = [
                "openid"
                "profile"
                "email"
              ];
              userinfo_signed_response_alg = "none";
            }
          ];
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
