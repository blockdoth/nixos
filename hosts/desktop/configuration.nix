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
    core.networking.hostname = "desktop";
    presets = {
      gui.enable = true;
      gaming.enable = true;
    };
    common = {
      syncthing.enable = true;
      bluetooth.enable = true;
      docker.enable = true;
      crosscompilation.enable = true;
    };
    services = {
      # githubrunners.enable = true;
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
