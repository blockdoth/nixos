{  config, lib, ... }:
{
  options = {
    system-modules.display.hyprland.enable = lib.mkEnableOption "Enables Hyprland";
  };

  config = lib.mkIf config.system-modules.display.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
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