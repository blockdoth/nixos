{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.windowmanager.hyprland;
in
{
  config = lib.mkIf module.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "waybar"
        "dunst"
        "hypridle"
        # "hyprlock --no-fade-in "
        "swww-daemon && swww img ../../../../../assets/wallpapers/waves.jpg"
        "pypr"
        "gammastep -b 1:1"
        "[workspace 1 silent] vesktop"
        "[workspace 2 silent] firefox"
        "[workspace 3 silent] codium"
        "activate-linux -f 'Noto Sans'"
        "hyprctl setcursor 15" # Fixes cursor sizes being different between apps
      ];
    };
  };
}
