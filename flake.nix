{
  description = "Pepijn's nix config";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
    	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {

    	laptop-pepijn = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
      	specialArgs = {inherit inputs;};
      	modules = [
        	./hosts/laptop-pepijn/configuration.nix
      	];
    	};
      
      laptop-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
      	specialArgs = {inherit inputs;};
      	modules = [
        	./hosts/laptop-server/configuration.nix
      	];
    	};

      desktop-pepijn = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
      	specialArgs = {inherit inputs;};
      	modules = [
        	./hosts/desktop-pepijn/configuration.nix
      	];
    	};
    };
  };
}
