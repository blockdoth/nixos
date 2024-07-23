{ pkgs, config, lib, ... }:
{  
  options = {
    git.enable = lib.mkEnableOption "Enables git";
  };

  config = lib.mkIf config.git.enable {
    home.packages = with pkgs; [
      lazygit
    ];

    programs = {
      git = {
        enable = true;    	
        userName = "PepijnVanEgmond";
        userEmail = "pepijn.pve@gmail.com";
        extraConfig = {    		
          init.defaultBranch = "main";
          push.autoSetupRemote = "true";
        };
      };
    };
  };
}
    
