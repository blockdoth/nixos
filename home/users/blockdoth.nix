{ pkgs, inputs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "blockdoth";
    homeDirectory = "/home/blockdoth";
    stateVersion = "24.05";
  };

  imports = [ ../modules/options.nix ];

  modules = {
    presets = {
      hyprland.enable = true;
      dev.enable = true;
      theming.enable = true;
      programs.enable = true;
    };

    # overrides
    programs.minecraft.enable = false;
    dev.editors.jetbrains.enable = false;
    programs = {
      filebrowser.nautilus.enable = false;
      activate-linux.enable = true;
      zenbrowser.enable = false;
      spotify.enable = true;
      llms.enable = false;
    };
  };
}
