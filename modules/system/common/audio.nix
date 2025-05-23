{ config, lib, ... }:
let
  module = config.system-modules.common.audio;
in
{
  config = lib.mkIf module.enable {
    security.rtkit.enable = true;

    # all disabled since it doesnt work
    # services.pipewire = {
    #   # enable = true;
    #   alsa = {
    #     enable = true;
    #     support32Bit = true;
    #   };
    #   wireplumber.enable = true;

    #   pulse.enable = true;
    #   jack.enable = true;
    # };

    # only pulse audio seems to work, not pipewire
    hardware = {
      enableAllFirmware = true;
    };
    services.pulseaudio = {
      enable = false;
      support32Bit = true;
    };

    # triggers a full local rebuild if set to false
    nixpkgs.config = {
      pulseaudio = true;
    };
  };
}
