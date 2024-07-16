{ config, lib, ... }:
{
  options = {
    bluetooth.enable = lib.mkEnableOption "Enables Bluetooth";
  };

  config = lib.mkIf config.bluetooth.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}