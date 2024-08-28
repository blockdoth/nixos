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
        support32Bit = false;
      };
      pulse.enable = false;
      wireplumber = {
        enable = false;

      };
    };
    
    hardware.pulseaudio.enable = false;
    # https://github.com/NixOS/nixpkgs/issues/319809
    sound.enable = true; # conflicts with pipewire
  };
}
