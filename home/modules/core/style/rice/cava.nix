{ pkgs, config, ... }:
{
  programs.cava = {
    enable = true;
    settings = {
      general = {
        mode = "normal";
        framerate = 60;
      };
      input = {
        method = "pipewire";
        source = "auto";
      };
      output.method = "noncurses";
      color = 
      let
        colors = config.lib.stylix.colors;
      in
      {
        gradient = 1;
        gradient_count = 5;
        gradient_color_1 = "'#${colors.base0B}'";
        gradient_color_2 = "'#${colors.base0C}'";
        gradient_color_3 = "'#${colors.base0A}'";
        gradient_color_4 = "'#${colors.base09}'";
        gradient_color_5 = "'#${colors.base08}'";

      };
      eq = {

      };
      smoothing.noise_reduction = 88;
    };
  };
}
  
  
  
  
