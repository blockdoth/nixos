{
  description = "Blockdoth's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # maybe one day
    # pog.url = "github:jpetrucciani/pog";
    linkwarden-pr.url = "github:jvanbruegge/nixpkgs/linkwarden"; # TODO remove when linkwarden gets merged
    sops-nix.url = "github:Mic92/sops-nix";
    stylix.url = "github:danth/stylix/d13ffb381c83b6139b9d67feff7addf18f8408fe";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix"; # Remove commit once its not broken anymore

    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
    nvf.url = "github:notashelf/nvf";

    nix-minecraft.url = "github:InfiniDoge/nix-minecraft";
    ags.url = "github:Aylur/ags";
    activate-linux.url = "github:MrGlockenspiel/activate-linux";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    iss-piss-stream.url = "github:blockdoth/iss-piss-stream/fed5758fb0da0d59b97e47d9037c4a37b7d40c8d";
    tree-but-cooler.url = "github:blockdoth/tree-but-cooler";
    ghostty.url = "github:ghostty-org/ghostty";
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #Prevents version mismatch TODO
    hyprland.url = "github:hyprwm/Hyprland/";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        # crossSystem = { config = "aarch64-linux"; };  # Enable cross-compilation
      };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/laptop/configuration.nix
          ];
        };
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/desktop/configuration.nix
          ];
        };
        nuc = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/nuc/configuration.nix
          ];
        };

        # Failed attempt at using nixos on an raspberry pi 2
        # rpi2 = nixpkgs.lib.nixosSystem {
        #   system = "armv7l-linux";
        #   specialArgs = {
        #     inherit inputs;
        #     crossSystem = {
        #       config = "aarch64-linux";  # Enable cross-compilation to ARM64 (Raspberry Pi)
        #     };
        #   };
        #   modules = [
        #     ./hosts/rpi/configuration.nix
        #     home-manager.nixosModules.home-manager
        #     inputs.stylix.nixosModules.stylix
        #   ];
        # };
      };

      homeConfigurations = {
        desktop-blockdoth = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            hostname = "desktop";
            inherit inputs;
          };
          modules = [
            users/blockdoth/home.nix
          ];
        };

        laptop-blockdoth = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            hostname = "laptop";

            inherit inputs;
          };
          modules = [
            users/blockdoth/home.nix
          ];
        };

        nuc-penger = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            hostname = "nuc";
            inherit inputs;
          };
          modules = [
            users/penger/home.nix
          ];
        };
      };
    };
}
