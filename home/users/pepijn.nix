{ pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "pepijn";
    homeDirectory = "/home/pepijn";
    stateVersion = "24.05";
  };

  imports = [
    ../modules/bundle.nix
  ];

  desktop.gui.enable = false;

  
  home.packages = [

  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };
  
}
