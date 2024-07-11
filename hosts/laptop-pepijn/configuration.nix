# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, pkgs, inputs, ... }:
let 
  theme = "oxocarbon-dark";
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/laptop-pepijn
      inputs.home-manager.nixosModules.laptop-pepijn
    ];

  networking = {
    hostName = "laptop-pepijn";
    networkmanager.enable = true;
    dhcpcd.wait = "background";
    dhcpcd.extraConfig = "noarp";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };


  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;


	programs = {
    fish.enable = true;
    hyprland = {
		  enable = true;
		  #package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      portalPackage = with pkgs; xdg-desktop-portal-hyprland;
    };
    nh = {
      enable = true;
      flake = "/home/pepijn/nixconfig/main";
    };
  };


  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
  };

	security.rtkit.enable = true;
	
  # Bluetooth support
  hardware = {
  	graphics.enable = true;
  };
  
  
  services = {
  	libinput = {
    	enable = true;
    	touchpad = {
      	tapping = true;
      	naturalScrolling = true;
      	scrollMethod = "twofinger";
    	};
  	};
  };

  security.sudo.wheelNeedsPassword = false;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
  
  users.users.pepijn = {
		shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel"  "docker" "networkmanager"];
  };

  virtualisation = {
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  home-manager = {
		backupFileExtension = "backup";
		useUserPackages = true;
		useGlobalPkgs = true;
		extraSpecialArgs = {inherit inputs;};
		users.pepijn = ../../home/laptop/home.nix;
	};

  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];

  system.stateVersion = "24.05";
}

