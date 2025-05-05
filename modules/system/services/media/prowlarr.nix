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
  module = cfg.prowlarr;
  mediaDir = cfg.mediaDir;
  mediaGroup = cfg.group;
  impermanence = config.system-modules.core.impermanence;
in
{
  config = lib.mkIf module.enable {
    # uses port 9696
    services.prowlarr = {
      enable = true;
      # group = mediaGroup;
    };

    system-modules.services = {
      network.caddy.reverse-proxies = [
        {
          subdomain = "prowlarr";
          port = 9696;
          require-auth = true;
        }
      ];
      observability.gatus.endpoints = [
        {
          name = "Prowlarr";
          url = "https://prowlarr.${domain}";
          endpoint = "/ping";
        }
      ];
    };

    environment.persistence."/persist/backup" = lib.mkIf impermanence.enable {
      directories = [
        {
          directory = "/var/lib/private/prowlarr";
          user = "prowlarr";
          group = "prowlarr";
          mode = "0755";
        }
      ];
    };
  };
}
