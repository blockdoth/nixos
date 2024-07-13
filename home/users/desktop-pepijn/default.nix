{ pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "desktop-pepijn";
    homeDirectory = "/home/desktop-pepijn";
    stateVersion = "24.05";
  };
    nixpkgs.config = {
      allowUnfree = true;
    };


  imports = [
    ../../modules/tools
    ../../modules/rice
    ../../modules/apps    
    ../../modules/system    
    ../../modules/desktop      
    ../../modules/editors 
  ];

  home.packages = [

  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };
  
}
