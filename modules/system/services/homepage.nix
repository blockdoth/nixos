{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.homepage;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.homepage-dashboard = {
      enable = true;
      listenPort = 8082;
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

    system-modules.services.network.caddy.reverse-proxies = [
      {
        subdomain = "homepage";
        port = config.services.homepage-dashboard.listenPort;
        require-auth = true;
      }
    ];

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Homepage";
        url = "https://homepage.${domain}";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
