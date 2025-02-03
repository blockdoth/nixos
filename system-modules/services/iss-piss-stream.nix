{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.iss-piss-stream.enable = lib.mkEnableOption "Enables iss-piss-stream";
  };

  config = lib.mkIf config.system-modules.services.iss-piss-stream.enable {
    environment.systemPackages = with pkgs; [
      inputs.iss-piss-stream.packages.${pkgs.system}.default
    ];

    systemd.services = {
      piss-stream-consumption = {
        description = "Logs the ISS piss stream";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${
            inputs.iss-piss-stream.packages.${pkgs.system}.default
          }/bin/iss-piss-stream -l -f -u ./var/log/pisslog.csv";
          Restart = "on-failure";
        };
      };
    };
  };
}
