{ pkgs, ... }:
{
  programs.home-manager.enable = true;
  home = {
    username = "penger";
    homeDirectory = "/home/penger";
    stateVersion = "24.05";
  };

  imports = [ ../modules/options.nix ];

  modules = {
    presets = {
      dev.enable = true;
      theming.enable = true;
    };

  };
}
