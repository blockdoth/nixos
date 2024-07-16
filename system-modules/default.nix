{config, lib, pkgs, ...}:
{
  imports = [
    ./bluetooth
    ./booting
    ./display
    ./gaming
    ./localisation
    ./networking
    ./nix-config
    ./printing
    ./audio
    ./ssh
    ./users
    ./virtualisation
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
    
    environment.systemPackages = with pkgs; [
      git
      home-manager
    ];

    booting.enable = true;
    networking.enable = true;
    localisation.enable = true;
    nix-config.enable = true;

    display.enable = config.system-modules.gui.enable;
    gaming.enable = if config.system-modules.gaming.enable then 
      if config.system-modules.gui.enable then 
        true 
      else 
        throw "GUI must be enabled to enable gaming"
    else 
      false;    
    audio.enable = config.system-modules.audio.enable;
    bluetooth.enable = config.system-modules.bluetooth.enable;
    headless.enable = config.system-modules.users.headless.enable;
    pepijn.enable = config.system-modules.users.pepijn.enable;
    assertMsg (false || false) "Must have at least one user defined" 
  };
}
