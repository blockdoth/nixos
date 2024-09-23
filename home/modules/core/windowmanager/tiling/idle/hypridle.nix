{ pkgs, lib, config, ... }: 
let
in {

  options = {
    modules.core.windowmanager.tiling.idle.hypridle.enable = lib.mkEnableOption "Enables hypridle";
  };

  config = lib.mkIf config.modules.core.windowmanager.tiling.idle.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on"; # turn on display after resume.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          lock_cmd = "hyprlock"; # lock screen.
        };

        listener = [
          {
            timeout = 900;
            on-timeout = "loginctl lock-session"; # lock screen.
          }
        ];
      };
    };
  };

}