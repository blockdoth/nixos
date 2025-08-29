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
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nix-on-droid.url = "github:nix-community/nix-on-droid/release-24.05";
    deploy-rs.url = "github:serokell/deploy-rs";
    # my repos
    iss-piss-stream.url = "github:blockdoth/iss-piss-stream/fed5758fb0da0d59b97e47d9037c4a37b7d40c8d";
    tree-but-cooler.url = "github:blockdoth/tree-but-cooler";
    chatger-registry.url = "github:blockdoth/chatger-registry";
    nixos-secrets.url = "git+ssh://git@github.com/blockdoth/nixos-secrets";

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-on-droid,
      deploy-rs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      deployPkgs = import nixpkgs {
        inherit system;
        overlays = [
          deploy-rs.overlays.default
          (self: super: {
            deploy-rs = {
              inherit (pkgs) deploy-rs;
              lib = super.deploy-rs.lib;
            };
          })
        ];
      };

      mkSystem =
        host:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/${host}/configuration.nix
            inputs.determinate.nixosModules.default
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

      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs { system = "aarch64-linux"; };
        modules = [ host/phone-redmi/configuration.nix ];
      };

      deploy.nodes = {
        nuc = {
          hostname = "nuc";
          profiles.system = {
            user = "deploy";
            sshUser = "deploy";
            path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.nuc;
          };
          profiles.penger = {
            user = "penger";
            sshUser = "penger";
            path = deployPkgs.deploy-rs.lib.activate.home-manager self.homeConfigurations.nuc-penger;
          };
        };
      };

      checks = { };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
