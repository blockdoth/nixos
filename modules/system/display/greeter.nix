{
  config,
  lib,
  pkgs,
  ...
}:

let
  module = config.system-modules.display.autologin;
in
{
  config = lib.mkIf module.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r -t --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    systemd.services.greetd = {
      serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };
  };
}
