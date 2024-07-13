{ config, pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "laptop-pepijn";
    homeDirectory = "/home/laptop-pepijn";
    stateVersion = "24.05";
  };
}