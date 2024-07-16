{ pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "pepijn";
    homeDirectory = "/home/pepijn";
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
    ../../modules/discord 
  ];

  home.packages = [

  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };
  
}
