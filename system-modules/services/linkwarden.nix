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
  config = lib.mkIf module.enable {
    # services.linkwarden = {
    #   enable = true;
    #   enableRegistration = true;
    #   openFirewall = false;
    # };
  };
}
