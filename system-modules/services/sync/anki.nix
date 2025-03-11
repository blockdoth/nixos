{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.sync.anki;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.anki-sync-server = {
      enable = true;
      address = "127.0.0.1";
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
