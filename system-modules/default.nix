{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  enableGui = config.system-modules.gui.enable;
  enableGaming = config.system-modules.gaming.enable;
  enableLaptop = config.system-modules.laptop.enable;
  enableUserPenger = config.system-modules.users.penger.enable;
  enableUserBlockdoth = config.system-modules.users.blockdoth.enable;
in
{
  imports = [
    ./core
    ./display
    ./services
    ./users/blockdoth.nix
    ./users/penger.nix
    ./audio.nix
    ./bluetooth.nix
    ./crosscompilation.nix
    ./gaming.nix
    ./power.nix
    ./printing.nix
    ./ssh.nix
    ./tailscale.nix
    ./docker.nix
  ];

  options = {
    system-modules = {
      gui.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      laptop.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      git
      home-manager
      micro
    ];

    environment.variables = {
      EDITOR = "micro";
    };

    system-modules = {
      common = {
        grub.enable = lib.mkDefault true;
        networking.enable = lib.mkDefault true;
        localisation.enable = lib.mkDefault true;
        nix-config.enable = lib.mkDefault true;
        secrets.enable = lib.mkDefault true;
      };

      display = {
        greeter.enable = lib.mkDefault enableGui;
        hyprland.enable = lib.mkDefault enableGui;
        x11.enable = lib.mkDefault enableGui;
      };
    };

    # Prevent me from fucking myself over again
    assertions = [
      {
        assertion = enableUserPenger || enableUserBlockdoth;
        message = "At least one user must be enabled";
      }
      {
        assertion = enableGui || !(enableGui && enableGaming);
        message = "To use the gaming module, the gui module must be enabled";
      }
    ];
  };
}
