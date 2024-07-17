{ pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "headless";
    homeDirectory = "/home/headless";
    stateVersion = "24.05";
  };

  imports = [
    ../modules
  ];

  modules.gui.enable = false;
  modules.cli-rice.enable = false;

  home.packages = [

  ];

  home.sessionVariables = {
    
  };
  
}