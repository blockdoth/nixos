{
  description = "Blockdoth's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    stylix.url = "github:danth/stylix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
    nvf.url = "github:notashelf/nvf";
    nix-minecraft.url = "github:InfiniDoge/nix-minecraft";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    shyfox.url = "github:blockdoth/ShyFox";
    ghostty.url = "github:ghostty-org/ghostty";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    activate-linux.url = "github:MrGlockenspiel/activate-linux";
    impermanence.url = "github:nix-community/impermanence";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    deploy-rs.url = "github:serokell/deploy-rs";
    # my repos
    iss-piss-stream.url = "github:blockdoth/iss-piss-stream/fed5758fb0da0d59b97e47d9037c4a37b7d40c8d";
    tree-but-cooler.url = "github:blockdoth/tree-but-cooler";
    chatger-registry.url = "github:blockdoth/chatger-registry";
    nixos-secrets.url = "git+ssh://git@github.com/blockdoth/nixos-secrets";
    # mowie.url = "git+ssh://git@gitlab.tudelft.nl/cor/robotics_minor/robotics_minor_2025/team_3_mowie/mowie.git?ref=dev";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
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
            inherit inputs user;
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
        clausum-desktop = mkHome "clausum" "desktop" "x86_64-linux";
        clausum-laptop = mkHome "clausum" "laptop" "x86_64-linux";
        blockdoth-laptop = mkHome "blockdoth" "laptop" "x86_64-linux";
        penger-nuc = mkHome "penger" "nuc" "x86_64-linux";
        mowie-rpi = mkHome "mowie" "rpi" "aarch64-linux";
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
            path = deployPkgs.deploy-rs.lib.activate.home-manager self.homeConfigurations.penger-nuc;
          };
        };
      };
    };
}
