{ pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "penger";
    homeDirectory = "/home/penger";
    stateVersion = "24.05";
  };

  imports = [ ../modules ];

  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "~/pictures/screenshots";
    XDG_DESKTOP_DIR = "~/desktop";
    XDG_DOCUMENTS_DIR = "~/documents";
    XDG_DOWNLOAD_DIR = "~/downloads";
    XDG_MUSIC_DIR = "~/music";
    XDG_PICTURES_DIR = "~/pictures";
    XDG_PUBLICSHARE_DIR = "~/public";
    XDG_TEMPLATES_DIR = "~/templates";
    XDG_VIDEOS_DIR = "~/videos";
  };
}
