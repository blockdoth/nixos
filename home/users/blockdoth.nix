{ pkgs, inputs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "blockdoth";
    homeDirectory = "/home/blockdoth";
    stateVersion = "24.05";
  };

  imports = [ ../modules ];

  modules = {
    hyprland.enable = true;
    dev.enable = true;
    theming.enable = true;
    programs.enable = true;

    # overrides
    core.windowmanager.tiling.mediadeamon.mpd.enable = false;
    core.windowmanager.tiling.wallpaper.hyprpaper.enable = false;
    programs.activate-linux.enable = true;
    programs.zenbrowser.enable = true;
    programs.spotify.enable = true;
  };

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "/home/blockdoth/Pictures/Screenshots";
  };

}
