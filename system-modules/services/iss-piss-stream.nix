{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.iss-piss-stream.enable = lib.mkEnableOption "Enables immich";
  };

  config =
    let
      xkcd-script = pkgs.stdenvNoCC.mkDerivation {
        pname = "xkcd script";
        version = "1.0";
        dontUnpack = true;
        src = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/ipython/xkcd-font/master/xkcd-script/font/xkcd-script.ttf";
          hash = "sha256-m43yVeJlYzWmoLtcQ965QaE8PcT4Wmv/xvCI3IQWM6w=";
        };
        installPhase = ''
          install -Dm755 $src $out/share/fonts/truetype/'xkcd Script'
        '';
      };
    in
    lib.mkIf config.system-modules.services.iss-piss-stream.enable {
      fonts.packages = [ xkcd-script ];

      systemd.services = {
        piss-stream-consumption = {
          description = "Logs the ISS piss stream";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          serviceConfig = {
            ExecStart = pkgs.writeShellScriptBin "prepAndRun" ''
              mkdir -p $HOME/services
              git clone git@github.com:blockdoth/iss-piss-stream.git $HOME/services/iss-piss-stream
              cd iss-piss-stream 
              git pull
              nix develop
              python main.py -l
            '';
            Restart = "on-failure";
          };
        };
        piss-stream-visualization = {
          description = "Visalizes the ISS piss stream and pushes it to github";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          serviceConfig = {
            ExecStart = pkgs.writeShellScriptBin "graphAndPush" ''
              cd $HOME/services/iss-piss-stream
              nix develop
              python graph.py -p
              git reset
              git add pissplot.png pislog.csv
              git commit -m "[Bot] Updated piss plot log"
              git push
            '';
            Restart = "on-failure";
          };
        };
        #        systemd.timers = {
        #          piss-stream-visualization-timer = {
        #            description = "Run piss-stream-visualization daily at midnight";
        #            wantedBy = [ "timers.target" ];
        #            timerConfig = {
        #              OnCalendar = "00:00:00";
        #              Unit = "piss-stream-visualization.service";
        #            };
        #          };
        #        };
      };
    };
}
