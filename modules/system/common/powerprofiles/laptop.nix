{ config, lib, ... }:
let
  module = config.system-modules.common.powerprofile;
in
{
  config = lib.mkIf (module == "laptop") {
    services = {
      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_SCALING_GOVERNOR_ON_AC = "performance";

          CPU_BOOST_ON_BAT = 0;
          CPU_BOOST_ON_AC = 1;

          CPU_DRIVER_OPMODE_ON_BAT = "active";
          CPU_DRIVER_OPMODE_ON_AC = "active";

          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          SCHED_POWERSAVE_ON_BAT = 1;

          START_CHARGE_THRESH_BAT0 = 40;
          STOP_CHARGE_THRESH_BAT0 = 80;

          WIFI_PWR_ON_AC = "off";
          WIFI_PWR_ON_BAT = "on";

          WOL_DISABLE = "N";

          RESTORE_DEVICE_STATE_ON_STARTUP = 1;
        };
      };
      upower.enable = true;
      power-profiles-daemon.enable = false;
      auto-cpufreq.enable = false;
      thermald.enable = true;
    };

    boot.kernelParams = [
      "pcie_aspm=force"
      "usbcore.autosuspend=1"
    ];
  };
}
