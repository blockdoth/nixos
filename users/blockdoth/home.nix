{
  hostname,
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
      gaming.enable = true;
    };
    programs = {
      browsers.zen.enable = true;
      blender.enable = true;
      gimp.enable = true;
      inkscape.enable = true;
    };
    dev = {
      ctf.enable = (if hostname == "laptop" then true else false);
      # nvf.enable = true;
      # jetbrains.enable = true;
    };
  };
}
