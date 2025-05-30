{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.windowmanager.tiling.nightmode.gammastep;
in
{
  config = lib.mkIf module.enable {
    services.gammastep = {
      enable = true;
      provider = "manual";
      latitude = 52.0;
      longitude = 5.0;
      temperature = {
        day = 6500;
        night = 3300;
      };
      settings = {
        general = {
          adjustment-method = "wayland";
          fade = "1";
          brightness-day = 1;
          brightness-night = 0.7;
          elevation-high = 3;
          elevation-low = -6;
        };
      };
    };
  };
}
