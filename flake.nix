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
      # laptop = nixpkgs.lib.nixosSystem {
      #   specialArgs = { inherit pkgs; };
      #   modules = [
      #     ./hosts/laptop/configuration.nix
      #     home-manager.nixosModules.home-manager         
      #     inputs.stylix.nixosModules.stylix
			# 	];
      # };
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs; };
        modules = [
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager         
				  inputs.stylix.nixosModules.stylix
        ];
    	};
      # server = nixpkgs.lib.nixosSystem {
      #   specialArgs = { inherit pkgs; };
      #   modules = [
      #     ./hosts/server/configuration.nix
      #     home-manager.nixosModules.home-manager         
			# 	  inputs.stylix.nixosModules.stylix
      #   ];
    	# };  
    };

    homeConfigurations = {
    	pepijn = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
      	modules = [
        	home/users/pepijn.nix
      	];
    	};
      headless = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
      	modules = [
        	home/users/headless.nix
      	];
    	};
    };
  };
}
