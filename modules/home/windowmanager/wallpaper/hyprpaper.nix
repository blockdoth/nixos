{
  config,
  lib,
  ...
}:
let
  module = config.modules.windowmanager.wallpaper.hyprpaper;
  wallpaperBasePath = "../../../../assets/wallpapers";
in
{
  config = lib.mkIf module.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ "${wallpaperBasePath}/castle.png" ];
        wallpaper = [ ",${wallpaperBasePath}/castle.png" ];
      };
    };
  };
}
