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

    services.pihole-ftl = {
      enable = true;
    };

    services.pihole-web = {
      enable = true;
      hostName = "pihole.${domain}";
    };
  };
}
