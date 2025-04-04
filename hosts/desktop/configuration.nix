{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../../modules/system/options.nix
    ./hardware.nix
  ];

  system-modules = {
    users.blockdoth.enable = true;
    core.networking.hostname = "desktop";
    presets = {
      gui.enable = true;
      gaming.enable = true;
    };
    common.syncthing.enable = true;
    services = {
      # gameservers.factorio.enable = true;
      # observability.gatus.enable = true;
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
