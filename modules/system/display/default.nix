{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./wayland.nix
    ./x11.nix
    ./greeter.nix
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
    #   xdg-desktop-portal-gtk
    extraPortals = with pkgs; [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
