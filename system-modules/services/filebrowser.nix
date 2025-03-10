{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.filebrowser.enable = lib.mkEnableOption "Enables filebrowser";
  };

  config =
    let
      domain = config.system-modules.services.domains.homelab;
    in
    lib.mkIf config.system-modules.services.filebrowser.enable {
      services.filebrowser = {
        enable = true;
        openRegistration = false;
        openFirewall = false;
        port = 8889;
      };

      services.caddy = {
        virtualHosts."filebrowser.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:${toString config.services.filebrowser.port}
        '';
      };
    };
}
