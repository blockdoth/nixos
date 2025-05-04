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
in
{
  config = lib.mkIf module.enable {
    system-modules.services.auth.authelia.port = 9091;
    sops.secrets = {
      authelia-jwt = {
        owner = "authelia-main";
        group = "authelia-main";
      };
      authelia-storage-encryption = {
        owner = "authelia-main";
        group = "authelia-main";
      };
      authelia-oidc-private-key = {
        owner = "authelia-main";
        group = "authelia-main";
      };
    };
    systemd.services.authelia-main.serviceConfig.SupplementaryGroups = [ lldap-config.shared-group ];

    services.authelia.instances.main = {
      enable = true;
      secrets = {
        jwtSecretFile = lldap-config.shared-jwt;
        storageEncryptionKeyFile = config.sops.secrets.authelia-storage-encryption.path;
        oidcIssuerPrivateKeyFile = config.sops.secrets.authelia-oidc-private-key.path;
      };
      environmentVariables = {
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = lldap-config.shared-password;
      };

      settings = {
        theme = "dark";
        log.level = "info";
        storage.local.path = "/var/lib/authelia-main/db.sqlite3";
        access_control = {
          default_policy = "one_factor";
          rules = [
            {
              domain = "*.${domain}";
              resources = [
                "^/health$"
                "^/healthcheck$"
              ];
              policy = "bypass";
            }
          ];
        };
        server = {
          address = "127.0.0.1:${builtins.toString module.port}";
          # Necessary for Caddy integration
          # See https://www.authelia.com/integration/proxies/caddy/#implementation
          endpoints.authz.forward-auth.implementation = "ForwardAuth";
        };

        authentication_backend.ldap = {
          implementation = "lldap";
          address = "ldap://127.0.0.1:${builtins.toString config.services.lldap.settings.ldap_port}";
          base_dn = "dc=example,dc=com";
          additional_users_dn = "ou=people";
          user = "uid=admin,ou=people,dc=example,dc=com";
          users_filter = "(&(|({username_attribute}={input})({mail_attribute}={input}))(objectClass=person))";
        };

        session = {
          cookies = [
            {
              domain = "${domain}";
              authelia_url = "https://auth.${domain}";
              default_redirection_url = "https://www.${domain}";
            }
          ];
          inactivity = "24h"; # 1 day
          expiration = "168h"; # 1 week
        };

        regulation = {
          max_retries = 3;
          find_time = 120;
          ban_time = 300;
        };
        notifier = {
          disable_startup_check = false;
          filesystem = {
            filename = "/var/lib/authelia-main/notification.txt"; # log path
          };
        };

        # TODO make this stub actually functional
        identity_providers.oidc.clients = [
          {
            authorization_policy = "one_factor";
            client_name = "immich";
            client_id = "immich";
            client_secret = "$pbkdf2-sha512$310000$l1GXEdjn4Ec/A5H9IHMTIg$2gyI3RvjK5mfWHTmSH7OL..74fd3aG6F/IPVKMfP.Ghsa/TN6patfBSWRLtpYH57pgMbN57MV8TIBkCN7XHjNw";
            public = false;
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
            userinfo_signed_response_alg = "RS256";
          }
        ];
      };
    };

    system-modules.services.network.caddy.reverse-proxies = [
      {
        subdomain = "auth";
        port = module.port;
      }
    ];

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Authelia";
        url = "https://auth.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
