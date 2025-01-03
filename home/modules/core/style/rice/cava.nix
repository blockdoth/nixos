{
  pkgs,
  config,
  lib,
  ...
}:
{

  options = {
    modules.core.style.cava.enable = lib.mkEnableOption "Enables cava";
  };

  config = lib.mkIf config.modules.core.style.cava.enable {
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
        color =
          let
            colors = config.lib.stylix.colors;
          in
          {
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
  };
}
