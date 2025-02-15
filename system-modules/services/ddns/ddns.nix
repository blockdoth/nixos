{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.ddns.enable = lib.mkEnableOption "Enables ddns";
  };

  config = lib.mkIf config.system-modules.services.ddns.enable {
    sops.secrets.cloudflare-ddns-api-token = { };

    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "update-ip";
        runtimeInputs = [
          (pkgs.writeShellApplication {
            name = "update-ip-unwrapped";
            text = builtins.readFile ./update-ip.sh;
          })
        ];
        text = "sudo cat ${config.sops.secrets.cloudflare-ddns-api-token.path} | update-ip-unwrapped";
      })
    ];

    systemd = {
      timers."ddns" = {
        wantedBy = [ "timers.target" ];
        partOf = [ "update-ip.service" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
      services."ddns" = {
        script = "update-ip";
        serviceConfig = {
          Environment = "PATH=/run/current-system/sw/bin";
          Type = "oneshot";
          User = "root";
        };
      };
    };
  };
}
