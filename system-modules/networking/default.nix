{config, lib, ... }:
{
  options = {
    networking.enable = lib.mkEnableOption "Enables networking";
  };

  config = lib.mkIf config.bluetooth.enable {
    networking = {
      hostName = "desktop-pepijn";
      networkmanager.enable = true;
    };
  };
}