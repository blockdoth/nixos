{ pkgs, inputs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "blockdoth";
    homeDirectory = "/home/blockdoth";
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
    XDG_SCREENSHOTS_DIR = "/home/blockdoth/Pictures/Screenshots";
  };
  
}
