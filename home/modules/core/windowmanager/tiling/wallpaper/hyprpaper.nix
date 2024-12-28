{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.core.windowmanager.tiling.wallpaper.hyprpaper.enable =
      lib.mkEnableOption "Enables hyprpaper";
  };

  config =
    let
      wallpaperBasePath = "../../../../../../assets/wallpapers";
    in
    lib.mkIf config.modules.core.windowmanager.tiling.wallpaper.hyprpaper.enable {
      services.hyprpaper = {
        enable = true;
        settings = {
          preload = [ "${wallpaperBasePath}/castle.png" ];
          wallpaper = [ ",${wallpaperBasePath}/castle.png" ];
        };
      };
    };
}
