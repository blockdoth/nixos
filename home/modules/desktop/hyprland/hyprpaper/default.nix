{inputs, pkgs, ...}: {
  services.hyprpaper = {
    package = inputs.hyprpaper.packages.${pkgs.system}.default;
    enable = true;
    settings = {
      preload = [
        "${../../../../../assets/wallpapers/basicblue.png}"
      ];
      wallpaper = [
        ",${../../../../../assets/wallpapers/basicblue.png}"
      ];
    };
  };
}