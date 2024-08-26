{ ...}:
{
  imports = [

    ./desktop/launcher/rofi.nix
    ./desktop/lockscreen/hyprlock.nix
    ./desktop/logout/wlogout.nix
    ./desktop/taskbar/waybar.nix
    ./desktop/wallpaper/hyprpaper.nix
    ./desktop/wallpaper/swww.nix
    ./desktop/widgets/pyprland.nix
    ./desktop/windowmanager/hyprland.nix

    ./services/idle/hypridle.nix
    ./services/nightmode/gammastep.nix
    ./services/notifications/dunst.nix

    ./style/fonts
    ./style/rice/rice.nix
    ./style/stylix.nix

    ./terminal/prompt/starship.nix
    ./terminal/shell/fish.nix
    ./terminal/alacritty.nix

    ./utils/utils.nix
    ./utils/git.nix
  ]; 
}