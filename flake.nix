{
  description = "Blockdoth's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # maybe one day
    linkwarden-pr.url = "github:jvanbruegge/nixpkgs/linkwarden"; # TODO remove when linkwarden gets merged
    sops-nix.url = "github:Mic92/sops-nix";
    stylix.url = "github:danth/stylix/d13ffb381c83b6139b9d67feff7addf18f8408fe";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix"; # Remove commit once its not broken anymore

    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
    nvf.url = "github:notashelf/nvf";
    nix-minecraft.url = "github:InfiniDoge/nix-minecraft";
    ags.url = "github:Aylur/ags";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    iss-piss-stream.url = "github:blockdoth/iss-piss-stream/fed5758fb0da0d59b97e47d9037c4a37b7d40c8d";
    tree-but-cooler.url = "github:blockdoth/tree-but-cooler";
    shyfox.url = "github:blockdoth/ShyFox";
    ghostty.url = "github:ghostty-org/ghostty";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprtasking = {
      url = "github:raybbian/hyprtasking";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
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
      };

      mkSystem =
        host:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/${host}/configuration.nix
          ];
        };

      mkHome =
        user: host:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            hostname = host;
            inherit inputs;
          };
          modules = [
            users/${user}/home.nix
          ];
        };
    in
    {
      nixosConfigurations = {
        laptop = mkSystem "laptop";
        desktop = mkSystem "desktop";
        nuc = mkSystem "nuc";
      };

      homeConfigurations = {
        desktop-blockdoth = mkHome "blockdoth" "desktop";
        laptop-blockdoth = mkHome "blockdoth" "laptop";
        nuc-penger = mkHome "penger" "nuc";
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
