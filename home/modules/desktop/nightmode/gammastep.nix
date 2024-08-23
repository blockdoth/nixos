{ pkgs, config, lib, ... }:
{
  options = {
    compositor.wayland.nightmode.gammastep.enable = lib.mkEnableOption "Enables hyprpaper";
  };

  config = lib.mkIf config.compositor.wayland.nightmode.gammastep.enable {
    services.gammastep = {
      enable = true;
      provider = "manual";
      latitude = 52.0;
      longitude = 5.0;
      temperature ={
        day = 6500;
        night = 3300;
      };
      settings = {
        general = {
          adjustment-method = "wayland";
          fade = "1";
          brightness-day = 1;
          brightness-night = 0.6;
          elevation-high = 3;
          elevation-low = -6;
        };
      };
    };
  };
}
