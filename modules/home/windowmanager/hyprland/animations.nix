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
      animations = {
        enabled = true;
        bezier = "overshot,   0.05,   0.9,  0.1,  1.05";
        animation = [
          "windows,       1,  5,   overshot"
          "windowsOut,    1,  7,   overshot"
          "windowsMove,   1,  6,   overshot"
          "workspaces,    1,  4,   default"
          "fade,          1,  6,   default"
          "border,        1,  10,  default"
          "borderangle,   1,  8,   default"
        ];
      };
    };
  };
}
