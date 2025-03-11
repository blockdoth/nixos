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
    core.networking.hostname = "desktop";
    presets = {
      gui.enable = true;
      gaming.enable = true;
    };
    common = {
      syncthing.enable = true;
    };
  };

  networking.hostName = "desktop";
  system.stateVersion = "24.05"; # Did you read the comment?
}
