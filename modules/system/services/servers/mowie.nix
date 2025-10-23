{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.scraping.iss-piss-stream;
  domain = config.system-modules.secrets.domains.mowie;
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = [
      inputs.mowie.packages.${pkgs.system}.mowie-web
    ];

    systemd.services = {
      iss-piss-stream = {
        description = "Runs mowie server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "mowie-web";
          Restart = "on-failure";
        };
      };
    };

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          domain = "${domain}";
          port = config.services.homepage-dashboard.listenPort;
          require-auth = true;
        }
      ];
    };
  };
}
