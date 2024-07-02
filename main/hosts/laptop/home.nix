{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "pepijn";
  home.homeDirectory = "/home/pepijn";


  home.packages = with pkgs; [
		cowsay
		alacritty
		discord
		vscodium
		
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
  			nswitch = "sudo nixos-rebuild switch --flake /home/pepijn/Documents/nix#laptop"; 
  			hswitch = "home-manager switch"; 
  			cls = "clear"; 
  			nh = "cd /home/pepijn/Documents/nix";
  		};
  	};
	};
	
	wayland.windowManager.hyprland = {
		enable = false;
		settings = {
			
		};
	};

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the calaonfiguration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/pepijn/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
