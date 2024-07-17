{ pkgs, ... }:
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

  modules.gui.enable = true;
  modules.cli-rice.enable = true;

  home.packages = [

  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };
  
}
