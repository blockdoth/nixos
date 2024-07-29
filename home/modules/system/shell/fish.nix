{ pkgs, config, lib, ... }:
{
	options = {
    shell.fish.enable = lib.mkEnableOption "Enables fish";
  };

  config = lib.mkIf config.shell.fish.enable {
  	programs.fish = {
  		enable = true;
			interactiveShellInit = ''
    		set fish_greeting # Disable greeting
  		'';
  		shellAliases = {
  			cls = "clear"; 
  			nh = "cd /home/pepijn/nixos"; 
  			hr-pepijn = "nh && home-manager switch --flake .#pepijn"; 
  			hr-headless = "nh && home-manager switch --flake .#headless"; 
  			sr-desktop = "nh && sudo nixos-rebuild switch --flake .#desktop"; 
  			sr-server = "nh && sudo nixos-rebuild switch --flake .#server"; 
  			sr-laptop = "nh && sudo nixos-rebuild switch --flake .#laptop"; 
  		};
 		};
  };
}



