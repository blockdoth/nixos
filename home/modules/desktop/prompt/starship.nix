{ pkgs, config, lib, ... }:
{
	options = {
    prompt.starship.enable = lib.mkEnableOption "starship";
  };

  config = lib.mkIf config.prompt.starship.enable {
  	programs.starship = {
  		enable = true;
 		};
  };
}



