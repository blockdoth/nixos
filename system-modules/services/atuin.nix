{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.atuin.enable = lib.mkEnableOption "Enables atuin";
  };

  config =
    let
      domain = config.system-modules.services.domains.homelab;
    in
    lib.mkIf config.system-modules.services.atuin.enable {
      services.atuin = {
        enable = true;
        openRegistration = false;
        openFirewall = false;
        port = 8889;
      };

      services.caddy = {
        virtualHosts."atuin.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:${toString config.services.atuin.port}
        '';
      };
    };
}
