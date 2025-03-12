{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.gameservers.factorio;
  domain = config.system-modules.services.network.domains.gameservers;
in
{
  config = lib.mkIf module.enable {
    services.factorio = {
      enable = true;
      port = 34197;
      description = "Factorio server running on nixos";
      nonBlockingSaving = true;

      # If public the username and password needs to be set
      public = false;
      username = "";
      password = "";
    };

    services.caddy = {
      virtualHosts."factorio.${domain}".extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.factorio.port}
      '';
    };
  };
}
