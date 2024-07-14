{ pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "desktop-pepijn";
    homeDirectory = "/home/desktop-pepijn";
    stateVersion = "24.05";
  };

  imports = [
    ../../modules/terminal
    ../../modules/vscode
    ../../modules/firefox    
    ../../modules/fonts    
    ../../modules/desktop      
    ../../modules/git 
    ../../modules/jetbrains 
    ../../modules/shell 
    ../../modules/rice 
  ];

  home.packages = [

  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };
  
}
