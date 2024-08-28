{
  description = "Blockdoth's nix config";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
    	inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix/8c507cb2256a7246817aef5cd9e7752099184d15";
    spicetify-nix.url = "github:the-argus/spicetify-nix/";
    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
    nix-minecraft.url = "github:InfiniDoge/nix-minecraft";
    
    #Prevents version mismatch TODO 
    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
  };

  outputs = { self, nixpkgs, home-manager, nixneovimplugins,spicetify-nix, ... }@inputs: 
	let
		system = "x86_64-linux";
		pkgs = import nixpkgs { 
      inherit system; 
      config.allowUnfree = true;
    # TODO figure out how to set up the NUR
    #   config.packageOverrides = pkgs: {1
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
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop/configuration.nix
          home-manager.nixosModules.home-manager         
				];
      };
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager         
        ];
    	};
      server = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/server/configuration.nix
          home-manager.nixosModules.home-manager         
        ];
    	};  
    };

    homeConfigurations = {
    	blockdoth = home-manager.lib.homeManagerConfiguration {
      	inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs.overlays = [
              nixneovimplugins.overlays.default
            ];
          }
          inputs.spicetify-nix.homeManagerModules.default
          inputs.stylix.homeManagerModules.stylix
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
