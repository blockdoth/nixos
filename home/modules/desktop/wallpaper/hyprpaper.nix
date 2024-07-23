{ pkgs, config, lib, ... }:
{
  options = {
    compositor.wayland.wallpaper.hyprpaper.enable = lib.mkEnableOption "Enables hyprpaper";
  };

  config = lib.mkIf config.compositor.wayland.wallpaper.hyprpaper.enable {
    home.packages = with pkgs; [
      hyprpaper
    ];

    services.hyprpaper = {
      # package = inputs.hyprpaper.packages.${pkgs.system}.default;
      enable = true;
      settings = {
        preload = [
          "wallpapers/pinkpanther.jpg"
        ];
        wallpaper = [
          "DP-3,wallpapers/pinkpanther.jpg"
        ];
      };
    };
  };
}