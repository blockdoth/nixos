{ config, lib, ... }:
{
  options = {
    audio.enable = lib.mkEnableOption "Enables sound";
  };

  config = lib.mkIf config.audio.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = false;
        support32Bit = true;
      };
      pulse.enable = false;
      jack.enable = false;
    };
    
    hardware.pulseaudio.enable = false;

    nixpkgs.config = {
      pulseaudio = false;
    };

    # https://github.com/NixOS/nixpkgs/issues/319809
    # sound.enable = true; conflicts with pipewire
  };
}