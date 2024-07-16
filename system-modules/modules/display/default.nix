{  config, lib, ...}:
{
  imports = [
    ./wayland.nix
    ./x11.nix
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