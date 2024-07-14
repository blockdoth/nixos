{ config, pkgs, ... }:

{
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

  sound.enable = true;
}