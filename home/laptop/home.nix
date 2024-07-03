{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "pepijn";
    homeDirectory = "/home/pepijn";
    stateVersion = "24.05";
  };
	
  programs.home-manager.enable = true;

  # Imports
  imports = [
    ./apps
		./system
		./rice
		./tools
    ./desktop
  ];
	
}
