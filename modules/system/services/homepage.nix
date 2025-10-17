{
  config,
  lib,
  ...
}:
let
  module = config.system-modules.services.homepage;
  domain = config.system-modules.secrets.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.homepage-dashboard = {
      enable = true;
      listenPort = 8082;
      allowedHosts = "127.0.0.1:8082,homepage.${domain}";
      settings = {

      };

      bookmarks = [
        {
          Dev = [
            {
              GH = [
                {
                  abbr = "Github";
                  href = "https://github.com/blockdoth";
                }
              ];
            }
          ];
        }
        {
          Media = [
            {
              YT = [
                {
                  abbr = "Youtube";
                  href = "https://github.com/blockdoth";
                }
              ];
            }
          ];
        }
        {
          Hosting = [
            {
              GA = [
                {
                  abbr = "Gatus";
                  href = "https://gatus.insinuatis.com";
                }
              ];
            }
          ];
        }
      ];

      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
            disk = "/";
          };
        }
      ];
    };

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "homepage";
          port = config.services.homepage-dashboard.listenPort;
          require-auth = true;
        }
      ];
      observability.healthchecks.endpoints = [
        {
          name = "Homepage";
          url = "https://homepage.${domain}";
          endpoint = "/api/healthcheck";
        }
      ];
    };
  };
}
