{
  config,
  lib,
  ...
}:
let
  domain = config.system-modules.secrets.domains.homelab;
  cfg = config.system-modules.services.media;
  module = cfg.prowlarr;
  impermanence = config.system-modules.core.impermanence;
in
{
  config = lib.mkIf module.enable {
    # uses port 9696
    services.prowlarr = {
      enable = true;
      # group = mediaGroup;
    };

    # systemd.tmpfiles.rules = [
    #   "d ${mediaDir}/torrents/prowlarr 0775 root ${mediaGroup} -"
    # ];

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "prowlarr";
          port = 9696;
          require-auth = true;
        }
      ];
      observability.healthchecks.endpoints = [
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
