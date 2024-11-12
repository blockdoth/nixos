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
    enable = true;
    gui.enable = true;
    audio.enable = true;
    bluetooth.enable = true;
    users = {
      blockdoth.enable = true;
    };

    laptop.enable = true;
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
