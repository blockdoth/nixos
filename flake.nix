{
  description = "Pepijn's nix config";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
    	inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
	let
		system = "x86_64-linux";
		pkgs = import nixpkgs { inherit system; config.allowUnfree = true;};
	in {

    nixosConfigurations = {
      laptop-pepijn = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs; };
        modules = [
          ./hosts/laptop-pepijn/configuration.nix
          home-manager.nixosModules.home-manager         
          inputs.stylix.nixosModules.stylix
				];
      };
      desktop-pepijn = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs; };
        modules = [
          ./hosts/desktop-pepijn/configuration.nix
          home-manager.nixosModules.home-manager         
				  inputs.stylix.nixosModules.stylix
        ];
    	};
    };

  # home-manager = {
	# 	backupFileExtension = "backup";
	# 	useUserPackages = true;
	# 	useGlobalPkgs = true;
	# 	extraSpecialArgs = {inherit inputs;};
	# 	users.desktop-pepijn = ../../home/users/desktop-pepijn;
	# };


    homeConfigurations = {
    	laptop-pepijn = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
      	modules = [
        	home/users/laptop-pepijn
      	];
    	};
      desktop-pepijn = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
      	modules = [
        	home/users/desktop-pepijn
      	];
    	};
    };
  };
}
