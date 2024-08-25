{ pkgs, config, lib, ... }:
{
  options = {
    modules.core.desktop.wallpaper.hyprpaper.enable = lib.mkEnableOption "Enables hyprpaper";
  };

  config = 
  let 
    wallpaper_path = "${./wallpapers/castle.png}";
  in
  lib.mkIf config.modules.core.desktop.wallpaper.hyprpaper.enable {
    services.hyprpaper = {
      # package = inputs.hyprpaper.packages.${pkgs.system}.default;
      enable = true;
      settings = {
        preload = [
          wallpaper_path
        ];
        wallpaper = [
          ",${wallpaper_path}"
        ];
      };
    };
  };


}