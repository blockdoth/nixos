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
    users.pepijn.enable = true;
  };
  


  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    image = ../../modules/desktop/wallpaper/wallpapers/pinkpanther.jpg;
  };

  networking.hostName = "desktop";
  system.stateVersion = "24.05"; # Did you read the comment?
}
