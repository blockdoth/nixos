{ pkgs, inputs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "pepijn";
    homeDirectory = "/home/pepijn";
    stateVersion = "24.05";
  };

  imports = [
    ../modules
  ];

  modules = {
    gui.enable = true;
    # custom-fonts.enable = true;
  };
  
  home.packages = with pkgs; [
    spotify
    vesktop
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    XDG_SCREENSHOTS_DIR = "/home/pepijn/Pictures/Screenshots";
  };
  
}
