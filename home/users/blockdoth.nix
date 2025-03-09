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
    dev.editors.jetbrains.enable = false;
    # overrides
    core.windowmanager.tiling.mediadeamon.mpd.enable = false;
    core.windowmanager.tiling.wallpaper.hyprpaper.enable = false;
    programs = {
      activate-linux.enable = true;
      zenbrowser.enable = true;
      spotify.enable = true;
      llms.enable = false;
    };
  };

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "$HOME/pictures/screenshots";
    XDG_DESKTOP_DIR = "$HOME/desktop";
    XDG_DOCUMENTS_DIR = "$HOME/documents";
    XDG_DOWNLOAD_DIR = "$HOME/downloads";
    XDG_MUSIC_DIR = "$HOME/music";
    XDG_PICTURES_DIR = "$HOME/pictures";
    XDG_VIDEOS_DIR = "$HOME/videos";
  };

}
