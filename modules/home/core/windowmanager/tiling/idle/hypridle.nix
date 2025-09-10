{
  pkgs,
  lib,
  config,
  ...
}:
let
  module = config.modules.core.windowmanager.tiling.idle.hypridle;
in
{
  config = lib.mkIf module.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on"; # turn on display after resume.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          lock_cmd = "pidof hyprlock | hyprlock"; # lock screen.
          ignore_dbus_inhibit = false;

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
