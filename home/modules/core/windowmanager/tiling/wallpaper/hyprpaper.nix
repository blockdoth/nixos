{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.windowmanager.tiling.wallpaper.hyprpaper;
  wallpaperBasePath = "../../../../../../assets/wallpapers";
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
