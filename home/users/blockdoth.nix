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
    gui.enable      = true;
    dev.enable      = true;
    theming.enable  = true;
    programs.enable = true;
    
  };


  home.sessionVariables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    XDG_SCREENSHOTS_DIR = "/home/blockdoth/Pictures/Screenshots";
  };
  
}
