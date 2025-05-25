{ config, lib, ... }:
let
  module = config.system-modules.common.audio;
in
{
  config = lib.mkIf module.enable {
    # security.rtkit.enable = true;
    hardware = {
      enableAllFirmware = true;
    };
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
