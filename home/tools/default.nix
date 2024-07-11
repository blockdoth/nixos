{pkgs, ...}: {
  home.packages = with pkgs; [
    # git already defined in system
    lazygit
    curl
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
}
    
