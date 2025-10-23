{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.servers.mowie;
  domain = config.system-modules.secrets.domains.mowie;
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = [
      inputs.mowie.packages.${pkgs.system}.mowie-web
    ];

    systemd.services = {
      mowie = {
        description = "Runs mowie server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${inputs.mowie.packages.${pkgs.system}.mowie-web}/bin/mowie-web";
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
