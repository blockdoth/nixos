{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../../system-modules/options.nix
    ./hardware.nix
  ];

  system-modules = {
    users.blockdoth.enable = true;
    core.networking.hostname = "laptop";
    presets = {
      gui.enable = true;
      laptop.enable = true;
    };
    common = {
      syncthing.enable = true;
      trackpad.enable = true;
    };
    services = {
      # observability.gatus.enable = true;
      network.authelia.enable = true;
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
