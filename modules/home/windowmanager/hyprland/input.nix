{
  config,
  lib,
  ...
}:
let
  module = config.modules.windowmanager.hyprland;
in
{
  config = lib.mkIf module.enable {
    wayland.windowManager.hyprland.settings = {
      input = {
        kb_layout = "us";
        kb_options = "caps:alt_modifier";
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0.2;
      };

      cursor = {
        # no_hardware_cursor = true;
        # persistent_warps = true;
        no_warps = true;
      };

    };
  };
}
