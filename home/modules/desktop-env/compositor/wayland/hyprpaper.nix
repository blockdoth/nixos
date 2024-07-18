{ pkgs, config, lib, ... }:
{
  options = {
    compositor.wayland.wallpaper.hyprpaper.enable = lib.mkEnableOption "Enables hyprpaper";
  };

  config = lib.mkIf config.compositor.wayland.wallpaper.hyprpaper.enable {
    services.hyprpaper = {
      # package = inputs.hyprpaper.packages.${pkgs.system}.default;
      enable = true;
      settings = {
        preload = [
          "../../../../../assets/wallpapers/basicblue.png"
        ];
        wallpaper = [
          "../../../../../assets/wallpapers/basicblue.png"
        ];
      };
    };
  };


}