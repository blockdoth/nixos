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
    	default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
      	specialArgs = {inherit inputs;};
      	modules = [
        	./users/default/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {inherit inputs;};
              users = {
			          "pepijn" = import /users/default/home.nix;
		          };
            };            
          }
      	];
    	};
    };
  };
}
