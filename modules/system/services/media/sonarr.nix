{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  domain = config.system-modules.services.network.domains.homelab;
  cfg = config.system-modules.services.media;
  module = cfg.sonarr;
  mediaDir = cfg.mediaDir;
  mediaGroup = cfg.group;
  impermanence = config.system-modules.core.impermanence;
in
{
  config = lib.mkIf module.enable {
    # Uses port 8989
    services.sonarr = {
      enable = true;
      group = mediaGroup;
    };

    # Fix insecure dependency
    nixpkgs.config.permittedInsecurePackages = [
      "aspnetcore-runtime-6.0.36"
      "aspnetcore-runtime-wrapped-6.0.36"
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-wrapped-6.0.428"
    ];

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents/sonarr 0775 root ${mediaGroup} -"
    ];

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "sonarr";
          port = 8989;
          require-auth = true;
        }
      ];
      observability.healthchecks.endpoints = [
        {
          name = "Sonarr";
          url = "https://sonarr.${domain}";
          endpoint = "/ping";
        }
      ];
    };

    environment.persistence."/persist/backup" = lib.mkIf impermanence.enable {
      directories = [
        {
          directory = "/var/lib/sonarr";
          user = "sonarr";
          group = mediaGroup;
          mode = "0755";
        }
      ];
    };
  };
}
