{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.servers.factorio;
  domain = config.system-modules.secrets.domains.public;
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

      observability.healthchecks.endpoints = [
        {
          name = "Factorio";
          url = "https://factorio.${domain}";
        }
      ];
    };
  };
}
