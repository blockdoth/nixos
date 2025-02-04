{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.acme.enable = lib.mkEnableOption "Enables acme";
  };

  config =
    let
      domain = config.system-modules.services.domains.iss-piss-stream;
    in
    lib.mkIf config.system-modules.services.acme.enable {
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
