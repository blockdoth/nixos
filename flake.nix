# __/\\\_________/\\\\\\______________________________________________________/\\\_______________________________/\\\_________        
#  _\/\\\________\////\\\_________________________________/\\\________________\/\\\______________________________\/\\\_________       
#   _\/\\\___________\/\\\________________________________\/\\\________________\/\\\____________________/\\\______\/\\\_________      
#    _\/\\\___________\/\\\________/\\\\\________/\\\\\\\\_\/\\\\\\\\___________\/\\\______/\\\\\_____/\\\\\\\\\\\_\/\\\_________     
#     _\/\\\\\\\\\_____\/\\\______/\\\///\\\____/\\\//////__\/\\\////\\\____/\\\\\\\\\____/\\\///\\\__\////\\\////__\/\\\\\\\\\\__    
#      _\/\\\////\\\____\/\\\_____/\\\__\//\\\__/\\\_________\/\\\\\\\\/____/\\\////\\\___/\\\__\//\\\____\/\\\______\/\\\/////\\\_   
#       _\/\\\__\/\\\____\/\\\____\//\\\__/\\\__\//\\\________\/\\\///\\\___\/\\\__\/\\\__\//\\\__/\\\_____\/\\\_/\\__\/\\\___\/\\\_  
#        _\/\\\\\\\\\___/\\\\\\\\\__\///\\\\\/____\///\\\\\\\\_\/\\\_\///\\\_\//\\\\\\\/\\__\///\\\\\/______\//\\\\\___\/\\\___\/\\\_ 
#         _\/////////___\/////////_____\/////________\////////__\///____\///___\///////\//_____\/////_________\/////____\///____\///__

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

    stylix.url = "github:danth/stylix/8c507cb2256a7246817aef5cd9e7752099184d15";
    spicetify-nix.url = "github:the-argus/spicetify-nix/";
    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
    nix-minecraft.url = "github:InfiniDoge/nix-minecraft";
    ags.url = "github:Aylur/ags";
    activate-linux.url = "github:MrGlockenspiel/activate-linux";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #Prevents version mismatch TODO 
    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
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

      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/laptop/configuration.nix
            home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
          ];
        };
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/desktop/configuration.nix
            home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
          ];
        };
        nuc = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/nuc/configuration.nix
            home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
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
            inputs.stylix.homeManagerModules.stylix
            home/users/blockdoth.nix
          ];
        };

        laptop-blockdoth = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            hostname = "laptop";
            inherit inputs;
          };
          modules = [
            inputs.stylix.homeManagerModules.stylix
            home/users/blockdoth.nix
          ];
        };

        nuc-penger = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            hostname = "nuc";
            inherit inputs;
          };
          modules = [
            inputs.stylix.homeManagerModules.stylix
            home/users/penger.nix
          ];
        };
      };
    };
}
