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
  imports = [
    "${inputs.linkwarden-pr}/nixos/modules/services/web-apps/linkwarden.nix"
  ];

  config = lib.mkIf module.enable {
    # environment.systemPackages = with pkgs; [
    #   inputs.linkwarden-pr.legacyPackages.${pkgs.system}.linkwarden
    # ];

    sops.secrets.linkwarden-nextauth = { };

    services.linkwarden = {
      enable = true;
      package = inputs.linkwarden-pr.legacyPackages.${pkgs.system}.linkwarden;
      enableRegistration = true;
      openFirewall = false;
      secretsFile = config.sops.secrets.linkwarden-nextauth.path;
    };
  };
}
