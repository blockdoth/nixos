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
    stylix.url = "github:danth/stylix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
    nvf.url = "github:notashelf/nvf";
    nix-minecraft.url = "github:InfiniDoge/nix-minecraft";
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
    activate-linux.url = "github:MrGlockenspiel/activate-linux";
    impermanence.url = "github:nix-community/impermanence";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nix-on-droid.url = "github:nix-community/nix-on-droid/release-24.05";
    deploy-rs.url = "github:serokell/deploy-rs";
    # my repos
    iss-piss-stream.url = "github:blockdoth/iss-piss-stream/fed5758fb0da0d59b97e47d9037c4a37b7d40c8d";
    tree-but-cooler.url = "github:blockdoth/tree-but-cooler";
    chatger-registry.url = "github:blockdoth/chatger-registry";
    nixos-secrets.url = "git+ssh://git@github.com/blockdoth/nixos-secrets";
    zjstatus.url = "github:dj95/zjstatus";
    mowie.url = "git+ssh://git@gitlab.tudelft.nl/cor/robotics_minor/robotics_minor_2025/team_3_mowie/mowie.git?ref=dev";
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
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      deployPkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [
          deploy-rs.overlays.default
          (self: super: {
            deploy-rs = {
              inherit (mkPkgs "x86_64-linux") deploy-rs;
              lib = super.deploy-rs.lib;
            };
          })
        ];
      };

      mkSystem =
        host: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/${host}/configuration.nix
            inputs.determinate.nixosModules.default
          ];
        };

      mkHome =
        user: host: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
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
        laptop = mkSystem "laptop" "x86_64-linux";
        desktop = mkSystem "desktop" "x86_64-linux";
        nuc = mkSystem "nuc" "x86_64-linux";
        rpi = mkSystem "rpi" "aarch64-linux";
      };

      homeConfigurations = {
        blockdoth-desktop = mkHome "blockdoth" "desktop" "x86_64-linux";
        blockdoth-laptop = mkHome "blockdoth" "laptop" "x86_64-linux";
        penger-nuc = mkHome "penger" "nuc" "x86_64-linux";
        mowie-rpi = mkHome "mowie" "rpi" "aarch64-linux";
      };

      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs { system = "aarch64-linux"; };
        modules = [ host/phone-redmi/configuration.nix ];
      };

      deploy.nodes = {
        nuc = {
          hostname = "nuc";
          profilesOrder = [ "system" ];
          fastConnection = true;
          profiles.system = {
            user = "root";
            sshUser = "penger";
            interactiveSudo = true;
            path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.nuc;
          };
          profiles.penger = {
            user = "penger";
            sshUser = "penger";
            path = deployPkgs.deploy-rs.lib.activate.home-manager self.homeConfigurations.nuc-penger;
          };
        };
      };
    };
}
