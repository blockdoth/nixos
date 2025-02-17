{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{

  options = {
    system-modules.services.linkwarden.enable = lib.mkEnableOption "Enables linkwarden";
  };

  config =
    let
      domain = config.system-modules.services.domains.homelab;
    in
    lib.mkIf config.system-modules.services.linkwarden.enable {
      # services.linkwarden = {
      #   enable = true;
      #   enableRegistration = true;
      #   openFirewall = false;
      # };
    };
}
