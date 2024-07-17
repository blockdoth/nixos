{  config, lib, ...}:
{
  imports = [
    ./wayland.nix
    ./x11.nix
  ];
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}