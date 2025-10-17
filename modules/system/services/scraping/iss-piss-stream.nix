{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.scraping.iss-piss-stream;
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = [
      inputs.iss-piss-stream.packages.${pkgs.system}.default
    ];

    systemd.services = {
      iss-piss-stream = {
        description = "Logs the ISS piss stream";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${
            inputs.iss-piss-stream.packages.${pkgs.system}.default
          }/bin/iss-piss-stream -l -f ./var/log/pisslog.csv";
          Restart = "on-failure";
        };
      };
    };
  };
}
