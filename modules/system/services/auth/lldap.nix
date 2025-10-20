{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.auth.lldap;
  domain = config.system-modules.secrets.domains.homelab;
  lldap-config = config.system-modules.services.auth.lldap;
in
{
  config = lib.mkIf module.enable {
    system-modules.services.auth.lldap = {
      shared-group = "lldap-shared";
      shared-jwt = config.sops.secrets.lldap-jwt.path;
      shared-password = config.sops.secrets.lldap-password.path;
    };

    users = {
      users.lldap = {
        isSystemUser = true;
        group = "lldap";
      };

      groups = {
        ${lldap-config.shared-group} = { };
        lldap = { };
      };
    };

    sops.secrets = {
      lldap-keyseed = {
        owner = "lldap";
        group = "lldap";
      };
      # Shared so require user and group read perms
      lldap-jwt = {
        owner = "lldap";
        group = lldap-config.shared-group;
        mode = "440";
      };
      lldap-password = {
        owner = "lldap";
        group = lldap-config.shared-group;
        mode = "440";
      };
    };

    systemd.services.lldap.serviceConfig.SupplementaryGroups = [ lldap-config.shared-group ];

    services.lldap = {
      enable = true;
      settings = {
        ldap_port = 3890;
        http_port = 17170;
        http_url = "http://127.0.0.1";
        ldap_base_dn = "dc=example,dc=com";
        ldap_user_dn = "uid=admin,ou=people,dc=example,dc=com";
        key_file = ""; # Silence warning
        force_ldap_user_pass_reset = "always";
      };
      environment = {
        LLDAP_JWT_SECRET_FILE = lldap-config.shared-jwt;
        LLDAP_LDAP_USER_PASS_FILE = lldap-config.shared-password;
        LLDAP_KEY_SEED_FILE = config.sops.secrets.lldap-keyseed.path;
      };

    };

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "lldap";
          port = config.services.lldap.settings.http_port;
        }
      ];
      observability.healthchecks.endpoints = [
        {
          name = "lldap";
          url = "https://lldap.${domain}";
        }
      ];
    };
  };
}
