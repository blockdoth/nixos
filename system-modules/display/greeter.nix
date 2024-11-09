{ config, lib, pkgs, ...}:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in 
{
  options = {
    system-modules.display.greeter.enable = lib.mkEnableOption "Enables greeter";
  };

  config = lib.mkIf config.system-modules.display.greeter.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --time --cmd hyprland";
          user = "greeter";
        };
      };
    };

    # this is a life saver.
    # literally no documentation about this anywhere.
    # might be good to write about this...
    # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
  #config = lib.mkIf config.greeter.enable {
    #TODO auto login and skipp greeter
  #};
}  
  
  
  
