# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let 
  theme = "oxocarbon-dark";
in {
  imports =
    [
      ./hardware.nix 
      ../../system/localisation
      ../../system/nix-config
      ../../system/pipewire
      ../../system/ssh  
      ../../system/boot/dual
      ../../system/display/x11
      inputs.home-manager.nixosModules.desktop-pepijn
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
    hostName = "desktop-pepijn";
    networkmanager.enable = true;
  };

	programs = {
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];

  system.stateVersion = "24.05"; # Did you read the comment?

}
