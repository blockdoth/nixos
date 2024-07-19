{ inputs, config, pkgs, lib, ... }:
{
  imports =[
    ./hardware.nix 
    ../../system-modules
  ];

  system-modules = {
    common.enable = true;
    gui.enable = true;
    gaming.enable = true;
    audio.enable = true;
    users.pepijn.enable = true;
  };
  
  networking.hostName = "desktop";

  system.stateVersion = "24.05"; # Did you read the comment?
}
