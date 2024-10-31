{ pkgs, config, lib, ... }:
{
	options = {
    modules.core.terminal.prompt.starship.enable = lib.mkEnableOption "starship";
  };

  config = lib.mkIf config.modules.core.terminal.prompt.starship.enable {
  	programs.starship = {
  		enable = true;
      enableTransience = false;
 		};
  };
}



