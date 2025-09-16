{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.network.blocky;
  domain = config.system-modules.secrets.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      pihole-web
      pihole
      pihole-ftl
    ];

    # services.pihole = {
    #   enable = true;

    # };
  };
}
