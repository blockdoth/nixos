{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.linkwarden;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  # Imports the module options from a unmerged nixpkgs pr
  imports = [
    "${inputs.linkwarden-pr}/nixos/modules/services/web-apps/linkwarden.nix"
  ];

  config = lib.mkIf module.enable {
    sops.secrets.linkwarden-nextauth = { };

    services.linkwarden = {
      enable = true;
      # Imports the actual package
      package = inputs.linkwarden-pr.legacyPackages.${pkgs.system}.linkwarden;

      port = 3001;
      host = "127.0.0.1";
      enableRegistration = false;
      openFirewall = false;
      secretsFile = config.sops.secrets.linkwarden-nextauth.path;
    };

    system-modules.services.network.caddy.reverse-proxies = [
      {
        subdomain = "linkwarden";
        port = config.services.linkwarden.port;
      }
    ];

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Linkwarden";
        url = "https://linkwarden.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
