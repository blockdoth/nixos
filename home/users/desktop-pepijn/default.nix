{ pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "laptop-pepijn";
    homeDirectory = "/home/pepijn";
    stateVersion = "24.05";
  };
}