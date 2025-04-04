{
  pkgs,
  inputs,
  config,
  hostname,
  lib,
  ...
}:
{
  imports = [
    ../../modules/home/options.nix
  ];

  home = {
    username = "penger";
    homeDirectory = "/home/penger";
    stateVersion = "24.05";
  };

  modules = {
    presets = {
      dev.enable = true;
      theming.enable = true;
    };
  };
}
