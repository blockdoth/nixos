{ pkgs, config, lib, ... }:
{
  options = {
    modules.core.desktop.wallpaper.hyprpaper.enable = lib.mkEnableOption "Enables hyprpaper";
  };

  config = 
  let 
    wallpaperBasePath = "../../../../../assets/wallpapers";
  in
  lib.mkIf config.modules.core.desktop.wallpaper.hyprpaper.enable {
    services.hyprpaper = {
      # package = inputs.hyprpaper.packages.${pkgs.system}.default;
      enable = true;
      settings = {
        preload = [
          "${wallpaperBasePath}/castle.png"
        ];
        wallpaper = [
          ",${wallpaperBasePath}/castle.png"
        ];
      };
    };
  };


}