{
  pkgs,
  config,
  lib,
  ...
}:
let
  colors = config.lib.stylix.colors;
in
{
  programs.cava = {
    enable = true;
    settings = {
      general = {
        mode = "normal";
        framerate = 60;
      };
      # autosens = "1";
      input = {
        method = "pulse";
        source = "auto";
      };
      output = {
        method = "noncurses";
        channels = "mono";
        mono_option = "average";
        reverse = "1";
      };
      color = {
        gradient = 1;
        gradient_color_1 = "'#${colors.base0D}'";
        gradient_color_2 = "'#${colors.base0C}'";
      };
      eq = {
      };
      smoothing = {
        monstercat = "1";
        noise_reduction = 40;
      };
    };
  };
}
