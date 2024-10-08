{ inputs, config, pkgs, lib, ... }:
{
  imports =[
    ./hardware.nix 
    ../../system-modules
  ];

  system-modules = {
    common.enable = true;
    gui.enable = true;
    audio.enable = true;
    gaming.enable = true;
    minecraftserver.enable = false;
    users.blockdoth.enable = true;
  };
  


  networking.hostName = "desktop";
  system.stateVersion = "24.05"; # Did you read the comment?
}
