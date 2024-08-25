{ config, lib, ...}:
{
  options = {
    power.enable = lib.mkEnableOption "Enables services required to manage power";
  };

  config = lib.mkIf config.power.enable {
    services = {
      upower.enable = true;
      power-profiles-daemon.enable = true;
    };
  };
}