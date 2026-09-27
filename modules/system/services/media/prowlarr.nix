{
  config,
  lib,
  ...
}:
let
  domain = config.system-modules.secrets.domains.homelab;
  cfg = config.system-modules.services.media;
  module = cfg.prowlarr;
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

  };
}
