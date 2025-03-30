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
  gatusIsEnabled = config.system-modules.services.observability.gatus.enable;
in
{
  config = lib.mkIf module.enable {
    sops.secrets.lldap-keyseed = { };

    services.lldap = {
      enable = true;
      settings = {
        ldap_port = 3890;
        http_port = 17170;
        http_url = "http://127.0.0.1";
        ldap_base_dn = "dc=ldap,dc=com";
      };
      environment = {
        LLDAP_JWT_SECRET_FILE = config.sops.secrets.authelia-jwt.path;
        LLDAP_KEY_SEED_FILE = config.sops.secrets.lldap-keyseed.path;
      };

    };

    services.caddy.virtualHosts."lldap.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${builtins.toString config.services.lldap.settings.http_port}        
    '';

    system-modules.services.observability.gatus.endpoints = lib.mkIf gatusIsEnabled [
      {
        name = "Lldap";
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
