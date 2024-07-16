{config, lib, pkgs, ...}:
{
  imports = [
    ./modules/display
    ./modules/users
    ./modules/audio.nix
    ./modules/bluetooth.nix
    ./modules/booting.nix
    ./modules/gaming.nix
    ./modules/networking.nix
    ./modules/nix-config.nix
    ./modules/localisation.nix
    ./modules/printing.nix
    ./modules/ssh.nix
    ./modules/virtualisation.nix
  ];

  options = {
    system-modules = {
      common.enable = lib.mkEnableOption "Enables the core services";
      gui.enable = lib.mkOption { 
        type = lib.types.bool;
        default = false;
      }; 
      gaming.enable = lib.mkOption { 
        type = lib.types.bool; 
        default = false;
      };
      audio.enable = lib.mkOption { 
        type = lib.types.bool; 
        default = false;
      };

      bluetooth.enable = lib.mkOption { 
        type = lib.types.bool; 
        default = false;
      };

      laptop.enable = lib.mkOption { 
        type = lib.types.bool; 
        default = false;
      };

      users.pepijn.enable = lib.mkOption { 
        type = lib.types.bool; 
        default = false;
      };

      users.headless.enable = lib.mkOption { 
        type = lib.types.bool; 
        default = false;
      };
    };
  };


  config = lib.mkIf config.system-modules.common.enable {
    
    # Define the base packages
    environment.systemPackages = with pkgs; [
      git
      home-manager
    ];

    # Enables the common modules
    booting.enable = true;
    networking.enable = true;
    localisation.enable = true;
    nix-config.enable = true;

    # Enables the optional modules
    gaming.enable = 
    if config.system-modules.gaming.enable then 
      if config.system-modules.gui.enable then 
        true 
      else 
        throw "GUI must be enabled to enable the gaming module"
    else 
      false;    
    
    display.enable = config.system-modules.gui.enable;
    audio.enable = config.system-modules.audio.enable;
    bluetooth.enable = config.system-modules.bluetooth.enable;

    # Enables the users, at least one must be defined
    headless.enable = config.system-modules.users.headless.enable;
    pepijn.enable = config.system-modules.users.pepijn.enable;

    # Prevent me from fucking myself over again
    assertions =
    [ 
      { 
        assertion = config.system-modules.users.headless.enable || config.system-modules.users.pepijn.enable;
        message = "At least one user must be enabled";
      }
    ];
  };
}
