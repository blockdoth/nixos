{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = config.system-modules.display.x11;
in
{
  config = lib.mkIf module.enable {
    services = {
      xserver = {
        enable = true;
      };
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    environment.gnome.excludePackages = (
      with pkgs;
      [
        gnome-photos
        gnome-tour
        gedit # text editor
        gnome-connections
        cheese # webcam tool
        gnome-music
        gnome-terminal
        epiphany # web browser
        geary # email reader
        evince # document viewer
        gnome-characters
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        baobab # disk usage analyzer
        epiphany # web browser
        simple-scan # document scanner
        totem # video player
        yelp # help viewer
        evince # document viewer
        geary # email client
        gnome-calculator
        gnome-contacts
        gnome-logs
        gnome-maps
        gnome-music
        gnome-screenshot
        gnome-system-monitor
      ]
    );
  };
}
