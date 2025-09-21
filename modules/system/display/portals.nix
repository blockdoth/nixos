{
  config,
  lib,
  pkgs,
  ...
}:
let
  waylandEnabled = config.system-modules.display.wayland.enable;
  x11Enabled = config.system-modules.display.x11.enable;
in
{
  config = lib.mkIf (waylandEnabled || x11Enabled) {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [
            "gtk"
            "hyprland"
          ];
        };
      };
    };
  };
}
