{ inputs, config, pkgs, lib, ... }:
{
  imports =[
    ./hardware.nix 
    ../../system-modules
  ];

  stylix.enable = true;
  stylix.base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/everforest.yaml";

  system-modules = {
    common.enable = true;
    gui.enable = true;
    gaming.enable = true;
    audio.enable = true;
  };
  
  system.stateVersion = "24.05"; # Did you read the comment?
}
