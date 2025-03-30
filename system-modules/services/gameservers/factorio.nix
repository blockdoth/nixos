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
  gatusIsEnabled = config.system-modules.services.observability.gatus.enable;
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      factorio-headless
    ];

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

    services.caddy.virtualHosts."factorio.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.factorio.port}
    '';

    system-modules.services.observability.gatus.endpoints = lib.mkIf gatusIsEnabled [
      {
        name = "Factorio";
        url = "https://factorio.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
