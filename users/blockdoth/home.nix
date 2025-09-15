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
    username = "blockdoth";
    homeDirectory = "/home/blockdoth";
    stateVersion = "24.05";
  };

  modules = {
    presets = {
      hyprland.enable = true;
      dev.enable = true;
      theming.enable = true;
      programs.enable = true;
      gaming.enable = (if hostname == "desktop" then true else false);
    };
  };
}
