{ config, lib, ... }:
{
  config = lib.mkIf config.modules.core.windowmanager.tiling.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      input = {
        kb_layout = "us";
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0.2;
      };

      cursor = {
        # no_hardware_cursor = true;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };
    };
  };
}
