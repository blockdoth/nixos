{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.core.windowmanager.tiling.hyprland;
in
{
  config = lib.mkIf module.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "waybar"
        "dunst"
        "hypridle"
        "hyprlock"
        "swww-daemon && swww img ../../../../../assets/wallpapers/rusty.jpg"
        "pypr"
        "gammastep -b 1:1"
        "[workspace 1 silent] firefox"
        "[workspace 2 silent] codium"
        "[workspace 3 silent] vesktop"
        "activate-linux"
        "hyprctl setcursor 15" # Fixes cursor sizes being different between apps
      ];
    };
  };
}
