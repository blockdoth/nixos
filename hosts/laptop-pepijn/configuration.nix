# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, pkgs, inputs, ... }:
let 
  theme = "oxocarbon-dark";
in {
  imports =
    [
      ./hardware.nix 
      ../../system/localisation
      ../../system/nix-config
      ../../system/pipewire
      ../../system/bluetooth
      ../../system/ssh  
      ../../system/boot/dual
      ../../system/display/x11
      inputs.home-manager.nixosModules.laptop-pepijn
    ];

  security.sudo.wheelNeedsPassword = false;
  users.users.pepijn = {
		shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel"  "docker" "networkmanager"];
  };

  home-manager = {
		backupFileExtension = "backup";
		useUserPackages = true;
		useGlobalPkgs = true;
		extraSpecialArgs = {inherit inputs;};
		users.pepijn = ../../home/laptop/home.nix;
	};

  networking = {
    hostName = "laptop-pepijn";
    networkmanager.enable = true;
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

	programs = {
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];

  system.stateVersion = "24.05";
}

