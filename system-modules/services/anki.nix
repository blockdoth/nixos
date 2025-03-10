{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.anki-sync.enable = lib.mkEnableOption "Enables anki";
  };

  config =
    let
      domain = config.system-modules.services.domains.homelab;
    in
    lib.mkIf config.system-modules.services.anki-sync.enable {
      services.anki-sync-server = {
        enable = true;
        users = [
          {
            username = "blockdoth";
            password = "8!mlzW72;1#!72Tb~>2OoLv[mARwZkazL9l[%=x3t^N(XdM~Mz";
            # passwordFile = config.sops.secrets.anki-password.path;
          }
        ];
        port = 27701;
      };

      services.caddy = {
        virtualHosts."anki.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:${toString config.services.anki-sync-server.port}
        '';
      };
    };
}
