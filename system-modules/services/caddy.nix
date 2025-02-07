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

        virtualHosts."${domain}".extraConfig = ''
          respond "Hello World"
        '';
      };
      users.users = {
        penger = lib.mkIf config.system-modules.users.penger.enable {
          extraGroups = [ "caddy" ];
        };
        blockdoth = lib.mkIf config.system-modules.users.blockdoth.enable {
          extraGroups = [ "caddy" ];
        };
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
