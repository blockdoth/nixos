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
    ./windowmanager/tiling/scratchpads/pyprland.nix

    ./style/fonts
    ./style/stylix.nix
    ./style/rice/cli.nix
    ./style/rice/gui.nix
    ./style/rice/cava.nix
    ./style/rice/fastfetch.nix

    ./terminal/shell/prompt/starship.nix
    ./terminal/shell/fish.nix
    ./terminal/shell/zoxide.nix
    ./terminal/shell/sync/atuin.nix
    ./terminal/alacritty.nix
    ./terminal/ghostty/ghostty.nix

    ./infra/secrets.nix
    ./infra/home-structure.nix
    ./infra/mimes.nix
    ./infra/cli-utils.nix
    # ./infra/impermanence.nix
    ./infra/gui-utils.nix
    ./infra/git.nix
  ];
}
