{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.filebrowser;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    # services.filebrowser = {
    #   enable = true;
    #   openRegistration = false;
    #   openFirewall = false;
    #   port = 8889;
    # };

    system-modules.services.network.caddy.reverse-proxies = [
      {
        subdomain = "filebrowser";
        port = config.services.filebrowser.listenPort;
      }
    ];
  };
}
