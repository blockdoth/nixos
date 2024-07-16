{  config, lib, ...}:
{
  imports = [
    ./wayland
    ./x11
  ];

  options = {
    display.enable = lib.mkEnableOption "Enables display servers";
  };

  config = lib.mkIf config.display.enable {
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    hyprland.enable = true;
    x11.enable = true;
  };
}