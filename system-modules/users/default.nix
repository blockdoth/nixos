{ config, lib, ...}:
{
  imports = [
    ./pepijn
    ./headless
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

    pepijn.enable = config.users.pepijn.enable;
    headless.enable = config.users.headless.enable;
  };
}