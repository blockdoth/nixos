{ config, lib, ... }:
let
  module = config.system-modules.common.powerprofile;
in
{
  config = lib.mkIf (module == "server") {
    services = {
      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
          CPU_BOOST_ON_AC = 1;
          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";

          DISK_IDLE_SECS_ON_AC = 300; # spin down after 5 min idle
          DISK_APM_LEVEL_ON_AC = "128"; # lower power mode for SSD/HDD

          USB_AUTOSUSPEND = 1;
          PCIE_ASPM_ON_AC = "powersupersave";
          RUNTIME_PM_ON_AC = "auto";

          WIFI_PWR_ON_AC = "off";
          WOL_DISABLE = "N";

          RESTORE_DEVICE_STATE_ON_STARTUP = 1;
        };
      };
    };

    boot.kernelParams = [
      "intel_idle.max_cstate=9"
      "processor.max_cstate=9"
      "pcie_aspm=force"
      "usbcore.autosuspend=1"
      "nvme_core.default_ps_max_latency_us=100"
    ];
  };
}
