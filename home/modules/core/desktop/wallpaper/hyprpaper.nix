{ pkgs, config, lib, ... }:
{
  options = {
    modules.core.desktop.wallpaper.hyprpaper.enable = lib.mkEnableOption "Enables hyprpaper";
  };

  config = 
  let 
    wallpaper_path = "${./wallpapers/pinkpanther.jpg}";
  in
  lib.mkIf config.modules.core.desktop.wallpaper.hyprpaper.enable {
    home.packages = with pkgs; [
      hyprpaper
    ];

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