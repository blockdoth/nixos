{config, lib, ... }:
{
  options = {
    networking.enable = lib.mkEnableOption "Enables networking";
  };

  config = lib.mkIf config.networking.enable {
    networking = {
      networkmanager = {
          enable = true;
          wifi.scanRandMacAddress = false;
      };
    };
  };
}