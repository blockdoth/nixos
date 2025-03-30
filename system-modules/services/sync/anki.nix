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
    sops.secrets.anki-password = { };
    services.anki-sync-server = {
      enable = true;
      address = "127.0.0.1";
      users = [
        {
          username = "blockdoth";
          passwordFile = config.sops.secrets.anki-password.path;
        }
      ];
      port = 27701;
    };

    services.caddy.virtualHosts."anki.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.anki-sync-server.port}
    '';
  };
}
