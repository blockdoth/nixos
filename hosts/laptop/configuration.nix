{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ./hardware.nix 
    ../../system-modules
  ];

  stylix.enable = true;
  stylix.base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/everforest.yaml";

  system-modules = {
    common.enable = true;
    gui.enable = true;
    sound.enable = true;
    bluetooth.enable = true;
    battery.enable = true;
    users.pepijn.enable = true;
  };

  networking.hostName = "laptop";

  services = {
  	libinput = {
    	enable = true;
    	touchpad = {
      	tapping = true;
      	naturalScrolling = true;
      	scrollMethod = "twofinger";
    	};
  	};
  };
  
  system.stateVersion = "24.05"; # Did you read the comment?
}
