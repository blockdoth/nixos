{
  description = "Blockdoth's nix config";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
    	inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
    
    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
  };

  outputs = { self, nixpkgs, home-manager, nixneovimplugins, ... }@inputs: 
	let
		system = "x86_64-linux";
		pkgs = import nixpkgs { 
      inherit system; 
      config.allowUnfree = true;
    # TODO figure out how to set up the NUR
    #   config.packageOverrides = pkgs: {
    #     nur = import (
    #       builtins.fetchTarball {
    #         url = "http://github.com/nix-community/NUR/archive/e78affd5313eef31717a16f81bc658f5e5be2154.tar.gz";
    #         sha256 = "17dkg56chx64a08f7z5wgikac3105n7p7y8wwdcxms36cqg7iz63";
    #       }
    #     ) {
    #     inherit pkgs;
    #   };
    # };
    };
	in {

    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs; inherit inputs; };
        modules = [
          ./hosts/laptop/configuration.nix
          home-manager.nixosModules.home-manager         
          inputs.stylix.nixosModules.stylix
				];
      };
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs; inherit inputs; };
        modules = [
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager         
				  inputs.stylix.nixosModules.stylix
        ];
    	};
      server = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs; inherit inputs; };
        modules = [
          ./hosts/server/configuration.nix
          home-manager.nixosModules.home-manager         
        ];
    	};  
    };

    homeConfigurations = {
    	blockdoth = home-manager.lib.homeManagerConfiguration {
      	inherit pkgs;
        modules = [
          {
            nixpkgs.overlays = [
              nixneovimplugins.overlays.default
            ];
          }
        	home/users/blockdoth.nix
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
