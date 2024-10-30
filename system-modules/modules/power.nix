{ config, lib, ...}:
{
  options = {
    system-modules.power.enable = lib.mkEnableOption "Enables services required to manage power";
  };

  config = lib.mkIf config.system-modules.power.enable {
    services = {
      upower.enable = true;
      power-profiles-daemon.enable = false;
      auto-cpufreq.enable = true;
    };
  };
}



