{ ... }:
{
  imports = [

    ./hyprland
    ./idle/hypridle.nix
    ./launcher/rofi.nix
    ./lockscreen/hyprlock.nix
    ./logout/wlogout.nix
    ./media/mpd.nix
    ./nightmode/gammastep.nix
    ./notifications/dunst.nix
    ./taskbar/waybar.nix
    ./wallpaper/hyprpaper.nix
    ./wallpaper/swww.nix
    ./scratchpads/pyprland.nix

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
