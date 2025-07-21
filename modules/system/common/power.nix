{ config, lib, ... }:
let
  module = config.system-modules.common.power;
in
{
  config = lib.mkIf module.enable {
    services = {
      upower.enable = true;
      power-profiles-daemon.enable = false;
      thermald.enable = true;
      auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
          };
          charger = {
            governor = "performance";
            turbo = "always";
          };
        };
      };
    };
  };
}
