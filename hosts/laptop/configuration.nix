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
    core.networking.hostname = "laptop";
    presets = {
      gui.enable = true;
      laptop.enable = true;
      # zenmode.enable = true;
    };
    common = {
      syncthing.enable = true;
      trackpad.enable = true;
    };
    services = {
      # observability.gatus.enable = true;
      # auth = {
      #   authelia.enable = true;
      #   lldap.enable = true;
      # };
      # homepage.enable = true;
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
