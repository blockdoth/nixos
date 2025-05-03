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
  lldap-secrets = "lldap-secrets";
in
{
  config = lib.mkIf module.enable {
    users.groups.lldap-secrets = { };
    users.users.lldap-secrets = {
      isNormalUser = true;
      group = lldap-secrets;
    };

    sops.secrets.lldap-keyseed = {
      owner = lldap-secrets;
      group = lldap-secrets;
    };
    sops.secrets.lldap-jwt = {
      owner = lldap-secrets;
      group = lldap-secrets;
    };

    systemd.services.lldap.serviceConfig.SupplementaryGroups = [ lldap-secrets ];

    services.lldap = {
      enable = true;
      settings = {
        ldap_port = 3890;
        http_port = 17170;
        http_url = "http://127.0.0.1";
        ldap_base_dn = "dc=ldap,dc=com";
      };
      environment = {
        LLDAP_JWT_SECRET_FILE = config.sops.secrets.lldap-jwt.path;
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
