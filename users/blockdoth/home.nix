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
      zenmode.enable = false;
    };

    # overrides
    programs.minecraft.enable = false;
    dev.editors = {
      jetbrains.enable = false;
      neovim.enable = false;
      nvf.enable = false;
    };
    programs = {
      filebrowser.nautilus.enable = false;
      browsers.zenbrowser.enable = false;
      activate-linux.enable = true;
      spotify.enable = true;
      llms.enable = false;
    };
  };
}
