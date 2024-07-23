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

  modules = {
    gui.enable = true;
  };
  
  home.packages = with pkgs; [
    #rice
    cmatrix
    fortune
    cowsay
    neofetch
    pipes
    cava
    cbonsai
    tty-clock
    btop

    #misc
    spotify
    vesktop
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };
  
}
