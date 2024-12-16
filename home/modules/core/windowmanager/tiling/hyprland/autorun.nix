{ config, lib, ... }:
{
  config = lib.mkIf config.modules.core.windowmanager.tiling.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "waybar"
        "dunst"
        "hypridle"
        "pkill hyprpaper"
        "swww-daemon && swww img ../../../../../assets/wallpapers/rusty.jpg"
        "pypr"
        "gammastep"
        "[workspace 1 silent] firefox"
        "[workspace 2 silent] codium"
        "[workspace 3 silent] vesktop"
        "activate-activate-linux"
      ];
    };
  };
}
