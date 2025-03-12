{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.network.authelia;
  domain = config.system-modules.services.network.domains.homelab;
  autheliaPort = 9091;
in
{
  config = lib.mkIf module.enable {
    sops.secrets = {
      authelia-jwt = { };
      authelia-storage-encryption = { };
    };

    services.authelia.instances.main = {
      enable = true;
      secrets = {
        jwtSecretFile = config.sops.secrets.authelia-jwt.path;
        storageEncryptionKeyFile = config.sops.secrets.authelia-storage-encryption.path;
      };
      settings = {
        server = {
          address = "http://127.0.0.1:${builtins.toString autheliaPort}";

          # Necessary for Caddy integration
          # See https://www.authelia.com/integration/proxies/caddy/#implementation
          endpoints.authz.forward-auth.implementation = "ForwardAuth";
        };
      };
    };

    services.caddy = {
      virtualHosts."authelia.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:${builtins.toString autheliaPort}        
      '';
    };
  };
}
