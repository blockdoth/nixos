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

    services.caddy = {
      virtualHosts."filebrowser.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.filebrowser.port}
      '';
    };
  };
}
