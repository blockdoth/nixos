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
    # (import ./disko.nix { device = "/dev/vda"; })
  ];

  system-modules = {
    users.blockdoth.enable = true;
    core.impermanence.enable = false;
    core.networking = {
      hostname = "desktop";
      wakeOnLan = true;
    };
    presets = {
      gui.enable = true;
      gaming.enable = true;
    };
    common = {
      bluetooth.enable = true;
      docker.enable = false;
      crosscompilation.enable = true;
      filemanager.enable = true;
    };
    services = {
      # network.pihole.enable = true;
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
