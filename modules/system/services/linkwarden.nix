{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.linkwarden;
  domain = config.system-modules.secrets.domains.homelab;
in
{
  # Imports the module options from a unmerged nixpkgs pr
  # imports = [
  #   "${inputs.linkwarden-pr}/nixos/modules/services/web-apps/linkwarden.nix"
  # ];

  # config = lib.mkIf module.enable {
  #   sops.secrets.linkwarden-secrets = { };

  #   services.linkwarden = {
  #     enable = true;
  #     # Imports the actual package
  #     package = inputs.linkwarden-pr.legacyPackages.${pkgs.system}.linkwarden;

  #     port = 3001;
  #     host = "127.0.0.1";
  #     enableRegistration = false;
  #     openFirewall = false;
  #     environmentFile = config.sops.secrets.linkwarden-secrets.path;

  #   };

  #   system-modules.services = {
  #     network.reverse-proxy.proxies = [
  #       {
  #         subdomain = "linkwarden";
  #         port = config.services.linkwarden.port;
  #         require-auth = true;
  #       }
  #     ];
  #     observability.healthchecks.endpoints = [
  #       {
  #         name = "Linkwarden";
  #         url = "https://linkwarden.${domain}";
  #         endpoint = "/api/v1/logins";
  #       }
  #     ];
  #   };
  # };
}
