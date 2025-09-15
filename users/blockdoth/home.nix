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
      # zenmode.enable = true;
    };

    # overrides
    programs.minecraft.enable = false;
    dev.editors = {
      vscode.enable = true;
      micro.enable = true;
    };
    programs = {
      browsers.zenbrowser.enable = false;
      spotify.enable = true;
    };
  };
}
