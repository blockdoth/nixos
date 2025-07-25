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

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "factorio";
          port = config.services.factorio.port;
        }
      ];

      observability.gatus.endpoints = [
        {
          name = "Factorio";
          url = "https://factorio.${domain}";
        }
      ];
    };
  };
}
