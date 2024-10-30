{config, lib, pkgs, inputs, ...}:
let 
  enableGui             = config.system-modules.gui.enable;
  enableGaming          = config.system-modules.gaming.enable;
  enableAudio           = config.system-modules.audio.enable; 
  enableVirtualisation  = config.system-modules.virtualisation.enable; 
  enableBluetooth       = config.system-modules.bluetooth.enable;
  enableSsh             = config.system-modules.ssh.enable;
  enableMinecraftServer = config.system-modules.minecraftserver.enable;
  enableLaptop          = config.system-modules.laptop.enable; 
  enableUserHeadless    = config.system-modules.users.headless.enable;
  enableUserBlockdoth   = config.system-modules.users.blockdoth.enable;
in
{
  imports = [
    ./modules/display
    ./modules/servers
    ./modules/users
    ./modules/audio.nix
    ./modules/bluetooth.nix
    ./modules/crosscompilation.nix
    ./modules/grub.nix
    ./modules/gaming.nix
    ./modules/greeter.nix
    ./modules/networking.nix
    ./modules/nix-config.nix
    ./modules/localisation.nix
    ./modules/power.nix
    ./modules/printing.nix
    ./modules/ssh.nix
    ./modules/virtualisation.nix
  ];

  options = {
    system-modules = {
      common.enable           = lib.mkEnableOption "Enables the core services";
      gui.enable              = lib.mkOption { type = lib.types.bool; default = false; }; 
      laptop.enable           = lib.mkOption { type = lib.types.bool; default = false; };
      users.blockdoth.enable  = lib.mkOption { type = lib.types.bool; default = false; };
      users.headless.enable   = lib.mkOption { type = lib.types.bool; default = false; };
    };
  };


  config = lib.mkIf config.system-modules.common.enable {
    
    # Define the base packages
    environment.systemPackages = with pkgs; [
      git
      home-manager
    ];
    system-modules = {
      # Enables the common modules
      grub.enable = lib.mkDefault true;
      networking.enable = true;
      localisation.enable = true;
      nix-config.enable = true;

      # Enables the optional modules
      greeter.enable = enableGui;
      hyprland.enable = enableGui;
      x11.enable = enableGui;
      power.enable = enableLaptop;

      headless.enable = config.system-modules.users.headless.enable;
      blockdoth.enable = config.system-modules.users.blockdoth.enable;
    };

    # Prevent me from fucking myself over again
    assertions =
    [ 
      { 
        assertion = enableUserHeadless || enableUserBlockdoth;
        message = "At least one user must be enabled";
      }
      { 
        assertion = enableGui || !(enableGui && enableGaming);
        message = "To use the gaming module, the gui module must be enabled";
      }
    ];
  };
}
