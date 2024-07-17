{config, lib, ... }:
{
  options = {
    networking.enable = lib.mkEnableOption "Enables networking";
  };

  config = lib.mkIf config.bluetooth.enable {
    networking = {
      networkmanager.enable = true;
    };
  };
}