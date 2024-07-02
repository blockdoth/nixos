{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "redpepijnyf";
    homeDirectory = "/home/pepijn";
    stateVersion = "24.05";
  };
  home-manager = {
		backupFileExtension = "backup";
		useUserPackages = true;
		useGlobalPkgs = true;
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
  ];

	programs = {
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];  
    };
		git = {
    	enable = true;
    	userName = "PepijnVanEgmond";
    	userEmail = "pepijn.pve@gmail.com";
    	extraConfig = {
    		init.defaultBranch = "main";
    		push.autoSetupRemote = "true";
    		credential.helper = "oauth";
    	};
  	};
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
