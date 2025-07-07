{
  config,
  lib,
  pkgs,
  ...
}:
let
  # tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  module = config.system-modules.display.autologin;
in
{
  config = lib.mkIf module.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "hyprland";
          user = "blockdoth";
        };
      };
    };

    # systemd.services.greetd.serviceConfig = {
    #   Type = "idle";
    #   StandardInput = "tty";
    #   StandardOutput = "tty";
    #   StandardError = "journal"; # Without this errors will spam on screen
    #   # Without these bootlogs will spam on screen
    #   TTYReset = true;
    #   TTYVHangup = true;
    #   TTYVTDisallocate = true;
    # };
  };
}
