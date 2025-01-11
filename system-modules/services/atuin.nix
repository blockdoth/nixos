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
      domain = "insinuatis.ddns.net";
    in
    lib.mkIf config.system-modules.services.atuin.enable {

      services.caddy = {
        enable = true;
        # email = "<e-mail>"; # Set your ACME registration email
        virtualHosts."atuin.${domain}".extraConfig = ''
          reverse_proxy * 127.0.0.1:${toString config.services.atuin.port}
        '';
      };

      services.atuin = {
        enable = true;
        openRegistration = true;
        openFirewall = false;
      };
    };
}
