{config, lib, pkgs, inputs, ...}:
let 
  enableGui           = config.system-modules.gui.enable;
  enableGaming        = config.system-modules.gaming.enable;
  enableAudio         = config.system-modules.audio.enable; 
  enableBluetooth     = config.system-modules.bluetooth.enable;
  enableUserHeadless  = config.system-modules.users.headless.enable;
  enableUserPepijn    = config.system-modules.users.pepijn.enable;
in
{
  imports = [
    ./modules/display
    ./modules/users
    ./modules/audio.nix
    ./modules/bluetooth.nix
    ./modules/booting.nix
    ./modules/gaming.nix
    ./modules/greeter.nix
    ./modules/networking.nix
    ./modules/nix-config.nix
    ./modules/localisation.nix
    ./modules/printing.nix
    ./modules/ssh.nix
    ./modules/virtualisation.nix
  ];

  options = {
    system-modules = {
      common.enable         = lib.mkEnableOption "Enables the core services";
      gui.enable            = lib.mkOption { type = lib.types.bool; default = false; }; 
      gaming.enable         = lib.mkOption { type = lib.types.bool; default = false; };
      audio.enable          = lib.mkOption { type = lib.types.bool; default = false; };
      bluetooth.enable      = lib.mkOption { type = lib.types.bool; default = false; };
      laptop.enable         = lib.mkOption { type = lib.types.bool; default = false; };
      users.pepijn.enable   = lib.mkOption { type = lib.types.bool; default = false; };
      users.headless.enable = lib.mkOption { type = lib.types.bool; default = false; };
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
    greeter.enable = true;

    # Enables the optional modules
    gaming.enable = enableGaming;
    hyprland.enable = enableGui;
    x11.enable = enableGui;
    audio.enable = enableAudio;
    bluetooth.enable = enableBluetooth;

    # Enables the users, at least one must be defined
    headless.enable = config.system-modules.users.headless.enable;
    pepijn.enable = config.system-modules.users.pepijn.enable;

    # Prevent me from fucking myself over again
    assertions =
    [ 
      { 
        assertion = enableUserHeadless || enableUserPepijn;
        message = "At least one user must be enabled";
      }
      { 
        assertion = enableGui || enableGui && enableGaming;
        message = "To use the gaming module, the gui module must be enabled";
      }
    ];
  };
}