{ pkgs, lib, config, ... }: 
let
  hyprlock = lib.getExe pkgs.hyprlock;
  loginctl = lib.getExe' pkgs.systemd "loginctl";
  systemctl = lib.getExe' pkgs.systemd "systemctl";
  hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";
in {

  options = {
    compositor.wayland.idle.hypridle.enable = lib.mkEnableOption "Enables hypridle";
  };

  config = lib.mkIf config.compositor.wayland.idle.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "${hyprctl} dispatch dpms on"; # turn on display after resume.
          before_sleep_cmd = "${loginctl} lock-session"; # lock before suspend.
          lock_cmd = "pidof hyprlock || ${hyprlock}"; # lock screen.
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "${loginctl} lock-session"; # lock screen.
          }
        ];
      };
    };
  };

}