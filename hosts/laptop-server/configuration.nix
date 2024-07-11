# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/laptop-server
      inputs.home-manager.nixosModules.laptop-server
    ];

  networking = {
    hostName = "laptop-server";
    networkmanager.enable = true;
    firewall = {
      firewall.enable = true;
      allowedTCPPorts = [ 80 443 22 ];
    };
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

	programs = {
    fish.enable = true;
    nh = {
      enable = true;
      flake = "/home/pepijn/nixconfig/main";
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.laptop-server = {
    isNormalUser = true;
    description = "laptop-server";
    extraGroups = [ "networkmanager" "wheel" ];
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

  system.stateVersion = "24.05"; # Did you read the comment?

}
