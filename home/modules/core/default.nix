{ ... }:
{
  imports = [

    ./windowmanager/stacking/gnome

    ./windowmanager/tiling/hyprland
    ./windowmanager/tiling/idle/hypridle.nix
    ./windowmanager/tiling/launcher/rofi.nix
    ./windowmanager/tiling/lockscreen/hyprlock.nix
    ./windowmanager/tiling/logout/wlogout.nix
    ./windowmanager/tiling/media/mpd.nix
    ./windowmanager/tiling/nightmode/gammastep.nix
    ./windowmanager/tiling/notifications/dunst.nix
    ./windowmanager/tiling/taskbar/waybar.nix
    ./windowmanager/tiling/wallpaper/hyprpaper.nix
    ./windowmanager/tiling/wallpaper/swww.nix
    ./windowmanager/tiling/widgets/pyprland.nix
    ./windowmanager/tiling/widgets/ags.nix

    ./style/fonts
    ./style/rice/rice.nix
    ./style/stylix.nix

    ./terminal/prompt/starship.nix
    ./terminal/shell/fish.nix
    ./terminal/alacritty.nix

    ./utils/git.nix
    ./utils/utils-cli.nix
    ./utils/utils-gui.nix
  ];
}
