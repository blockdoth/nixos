{ config, pkgs, ... }:

{
  security.rtkit.enable = true;
  services.pipewire = {
		enable = true;
		alsa = {
      enable = true;
      support32Bit = true;
    };
		pulse.enable = false;
		# jack.enable = true;
  };
  
  nixpkgs.config = {
  	pulseaudio = true;
  };

  sound.enable = true;
}