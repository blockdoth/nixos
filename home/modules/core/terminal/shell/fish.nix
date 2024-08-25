{ pkgs, config, lib, ... }:
{
	options = {
    modules.core.terminal.shell.fish.enable = lib.mkEnableOption "Enables fish";
  };

  config = lib.mkIf config.modules.core.terminal.shell.fish.enable {
  	programs.fish = {
  		enable = true;
			interactiveShellInit = ''
    		set fish_greeting # Disable greeting
  		'';
  		shellAliases = {
  			cls = "clear"; 
  			nh = "cd /home/blockdoth/nixos"; 
  			hr-blockdoth = "nh && home-manager switch --flake .#blockdoth"; 
  			hr-headless = "nh && home-manager switch --flake .#headless"; 
  			nr-desktop = "nh && sudo nixos-rebuild switch --flake .#desktop"; 
  			nr-server = "nh && sudo nixos-rebuild switch --flake .#server"; 
  			nr-laptop = "nh && sudo nixos-rebuild switch --flake .#laptop"; 
  			bdir = "nautilus --select . &"; 
  		};
 		};
  };
}



