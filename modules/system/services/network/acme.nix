{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.network.acme;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    sops.secrets.acme-cloudflare-api-key = { };

    security.acme = {
      acceptTerms = true;
      certs.${domain} = {
        dnsProvider = "cloudflare";
        email = "pepijn.pve@gmail.com";
        credentialFiles = {
          "CF_DNS_API_TOKEN_FILE" = config.sops.secrets.acme-cloudflare-api-key.path;
        };
      };
    };
  };
}
