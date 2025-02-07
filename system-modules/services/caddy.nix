{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.caddy.enable = lib.mkEnableOption "Enables caddy";
  };

  config =
    let
      domain = config.system-modules.services.domains.iss-piss-stream;
      certPath = "/var/lib/acme/${domain}/fullchain.pem";
      keyPath = "/var/lib/acme/${domain}/privkey.pem";
    in
    lib.mkIf config.system-modules.services.caddy.enable {
      services.caddy = {
        enable = true;
        email = "pepijn.pve@gmail.com";

        # globalConfig = ''
        #   tls ${certPath} ${keyPath}
        # '';

        virtualHosts."${domain}".extraConfig = ''
          respond "Hello World"
        '';
      };

      networking.firewall = {
        allowedTCPPorts = [
          80
          443
        ];
      };
      users.users.caddy.extraGroups = [ "acme" ];
    };
}
