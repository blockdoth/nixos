{ config, lib, ... }:
let
  module = config.system-modules.common.power;
in
{
  config = lib.mkIf module.enable {
    services = {
      upower.enable = true;
      power-profiles-daemon.enable = false;
      auto-cpufreq.enable = true;
    };
  };
}
