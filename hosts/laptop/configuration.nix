{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../system-modules
  ];

  system-modules = {
    gui.enable = true;
    audio.enable = true;
    bluetooth.enable = true;
    users = {
      blockdoth.enable = true;
    };
    ssh.enable = true;
    power.enable = true;
    laptop.enable = true;
    tailscale.enable = true;
    # display.x11.enable = false;

    services = {
      syncthing.enable = true;
      caddy.enable = false;
      nextcloud.enable = false;
      mediaserver.enable = false;
    };
  };

  services = {
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        scrollMethod = "twofinger";
      };
    };
  };

  networking.hostName = "laptop";

  system.stateVersion = "24.05"; # Did you read the comment?
}
