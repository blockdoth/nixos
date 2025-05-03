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
  lldap-secrets = config.system-modules.services.auth.lldap.password;
in
{
  config = lib.mkIf module.enable {
    users = {
      groups = {
        lldap-secrets = { };
        lldap = { };
      };
      users.lldap = {
        isNormalUser = true;
        group = "lldap";
      };
    };

    sops.secrets = {
      lldap-keyseed = {
        owner = "lldap";
        group = "lldap";
      };
      lldap-jwt = {
        owner = "lldap";
        group = "lldap";
      };
      lldap-password = {
        owner = "lldap";
        group = lldap-secrets;
      };
    };

    systemd.services.lldap.serviceConfig.SupplementaryGroups = [ lldap-secrets ];

    services.lldap = {
      enable = true;
      settings = {
        ldap_port = 3890;
        http_port = 17170;
        http_url = "http://127.0.0.1";
        ldap_base_dn = "dc=ldap,dc=com";
        ldap_user_dn = "admin";
      };
      environment = {
        LLDAP_JWT_SECRET_FILE = config.sops.secrets.lldap-jwt.path;
        LLDAP_KEY_SEED_FILE = config.sops.secrets.lldap-keyseed.path;
        LLDAP_LDAP_USER_PASS_FILE = config.sops.secrets.lldap-keyseed.path;
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
