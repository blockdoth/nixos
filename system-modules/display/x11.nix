{ config, lib, ... }:
{
  options = {
    system-modules.display.x11.enable = lib.mkEnableOption "Enables X11";
  };

  config = lib.mkIf config.system-modules.display.x11.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      # extraPortals = with pkgs; [
      #   xdg-desktop-portal-gtk
      # ];
    };  
  };
}