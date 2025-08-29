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
  imports = [
    ./wayland.nix
    ./x11.nix
    ./greeter.nix
  ];

  config = lib.mkIf (waylandEnabled || x11Enabled) {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      config.common.default = "*";
      extraPortals = with pkgs; [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
