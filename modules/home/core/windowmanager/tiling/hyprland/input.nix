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
      input = {
        kb_layout = "us";
        kb_options = "caps:none";
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
