{ config, pkgs, ... }:
{
  imports = [
      ./hardware.nix 
      ../../system/localisation
      ../../system/nix-config
      ../../system/ssh  
      ../../system/boot/single
      inputs.home-manager.nixosModules.laptop-server
    ];

  users.users.server = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
		backupFileExtension = "backup";
		useUserPackages = true;
		useGlobalPkgs = true;
		extraSpecialArgs = {inherit inputs;};
		users.pepijn = ../../home/laptop/home.nix;
	};

  networking = {
    hostName = "laptop-server";
    networkmanager.enable = true;
    firewall = {
      firewall.enable = true;
      allowedTCPPorts = [ 80 443 22 ];
    };
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
