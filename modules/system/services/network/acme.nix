{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.network.acme;
  domain = config.system-modules.secrets.domains.homelab;
  mail = config.system-modules.secrets.mails.personal;
in
{
  config = lib.mkIf module.enable {
    sops.secrets.acme-cloudflare-api-key = { };

    security.acme = {
      acceptTerms = true;
      certs.${domain} = {
        dnsProvider = "cloudflare";
        email = "${mail}";
        credentialFiles = {
          "CF_DNS_API_TOKEN_FILE" = config.sops.secrets.acme-cloudflare-api-key.path;
        };
        extraDomainNames = [ "*.${domain}" ];
      };
    };
  };
}
