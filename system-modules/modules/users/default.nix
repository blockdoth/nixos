{ config, lib, ...}:
{
  imports = [
    ./pepijn.nix
    ./headless.nix
  ];

  options = {
    users.pepijn.enable = lib.mkOption { 
      type = lib.types.bool; 
      default = false;
    };
    users.headless.enable = lib.mkOption { 
      type = lib.types.bool; 
      default = false;
    };
  };

  config = {
    programs = {
      fish.enable = true; 
    };

    pepijn.enable = lib.mkDefault config.users.pepijn.enable;
    headless.enable = lib.mkDefault config.users.headless.enable;
  };
}
