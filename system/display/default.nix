{ pkgs, ...}:
{
  imports = [
    ./x11
    ./wayland
  ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    dextraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}