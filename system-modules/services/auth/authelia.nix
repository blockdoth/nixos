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
  gatusIsEnabled = config.system-modules.services.observability.gatus.enable;
  autheliaPort = 9091;
in
{
  config = lib.mkIf module.enable {
    sops.secrets = {
      authelia-jwt = { };
      authelia-storage-encryption = { };
      lldap-password = { };
    };

    services.authelia.instances.main = {
      enable = true;
      secrets = {
        jwtSecretFile = config.sops.secrets.authelia-jwt.path;
        storageEncryptionKeyFile = config.sops.secrets.authelia-storage-encryption.path;
      };
      environmentVariables = with config.sops; {
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = secrets.lldap-password.path;
      };

      settings = {
        server = {
          address = "tcp:127.0.0.1:${builtins.toString autheliaPort}";

          # Necessary for Caddy integration
          # See https://www.authelia.com/integration/proxies/caddy/#implementation
          endpoints.authz.forward-auth.implementation = "ForwardAuth";
        };
        logs.level = "info";

        notifier = {
          enable = false;
          # SMTP configuration for sending emails
          # smtp = {
          #   host = "smtp.example.com";
          #   port = 587;
          #   username = "user@example.com";
          #   password = "your-smtp-password";
          #   from = "authelia@example.com";
          #   subject_prefix = "[Authelia] ";
          # };
        };

      };
    };

    services.caddy.virtualHosts."authelia.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${builtins.toString autheliaPort}        
    '';

    system-modules.services.observability.gatus.endpoints = lib.mkIf gatusIsEnabled [
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
