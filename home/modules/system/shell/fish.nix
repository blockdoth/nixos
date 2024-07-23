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
  		};
 		};
  };
}



