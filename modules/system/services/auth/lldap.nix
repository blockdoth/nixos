{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.auth.lldap;
  domain = config.system-modules.services.network.domains.homelab;
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
        isNormalUser = true;
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
      lldap-jwt = {
        owner = "lldap";
        group = lldap-config.shared-group;
      };
      lldap-password = {
        owner = "lldap";
        group = lldap-config.shared-group;
      };
    };

    systemd.services.lldap.serviceConfig.SupplementaryGroups = [ lldap-config.shared-group ];

    services.lldap = {
      enable = true;
      settings = {
        ldap_port = 3890;
        http_port = 17170;
        http_url = "http://127.0.0.1";
        ldap_base_dn = "dc=ldap,dc=com";
        ldap_user_dn = "admin";
        key_file = ""; # Silence warning
      };
      environment = {
        LLDAP_JWT_SECRET_FILE = lldap-config.shared-jwt;
        LLDAP_LDAP_USER_PASS_FILE = lldap-config.shared-password;
        LLDAP_KEY_SEED_FILE = config.sops.secrets.lldap-keyseed.path;
      };

    };

    services.caddy.virtualHosts."lldap.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${builtins.toString config.services.lldap.settings.http_port}        
    '';

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "lldap";
        url = "https://lldap.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
