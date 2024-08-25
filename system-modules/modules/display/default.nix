{  config, lib, pkgs, ...}:
{
  imports = [
    ./wayland.nix
    ./x11.nix
  ];
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # extraPortals = with pkgs; [
    #   xdg-desktop-portal-gtk
    # ];
  };
}