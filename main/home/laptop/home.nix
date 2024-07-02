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

  home.packages = with pkgs; [
		cowsay
		alacritty
		discord
		vscodium		
	];

  # Imports
  imports = [
    ./apps
		./desktop
		./rice
		./tools
		./fonts
		./shell
  ];

	programs = {
  	fish = {
  		enable = true;
  		shellAliases = {
  			nswitch = "sudo nixos-rebuild switch --flake /home/pepijn/nixconfig/main#default"; 
  			hswitch = "home-manager switch"; 
  			cls = "clear"; 
  			nh = "cd /home/pepijn/nixconfig/main";
  		};
  	};
	};
	
	wayland.windowManager.hyprland = {
		enable = false;
		settings = {
			
		};
	};


}
