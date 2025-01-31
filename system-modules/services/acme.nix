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
      domain = "insinuatis.com";
    in
    lib.mkIf config.system-modules.services.acme.enable {
      security.acme = {
        acceptTerms = true;
        certs.${domain} = {
          dnsProvider = "cloudflare";
          email = "pepijn.pve@gmail.com";
          credentialFiles = {
            "CLOUDFLARE_EMAIL_FILE" = config.sops.secrets.acme-cloudflare-email.path;
            "CLOUDFLARE_API_KEY_FILE" = config.sops.secrets.acme-cloudflare-api-key.path;
          };
        };
      };
    };
}
