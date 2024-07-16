{ config, lib, ... }:
{
  options = {
    x11.enable = lib.mkEnableOption "Enables X11";
  };

  config = lib.mkIf config.x11.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };  
  };
}