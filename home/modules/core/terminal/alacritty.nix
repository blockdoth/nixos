{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.core.terminal.alacritty.enable = lib.mkEnableOption "Enables alacritty";
  };

  config = lib.mkIf config.modules.core.terminal.alacritty.enable {
    home.packages = with pkgs; [ alacritty ];
    home.sessionVariables = {
      TERMINAL = "alacritty";
    };

    programs.alacritty = {
      enable = true;
      settings = {
        env = {
          "TERM" = "xterm-256color";
        };

        window = {
          # opacity = 0.7;
          padding.x = 10;
          padding.y = 10;
          decorations = "buttonless";
        };

        # handled by stylix
        font = {
          # size = 10.0;
          # normal.family = "FuraCode Nerd Font";
          # bold.family = "FuraCode Nerd Font";
          # italic.family = "FuraCode Nerd Font";
        };

        cursor.style = "Beam";

        shell = {
          program = "fish";
          args = [
            "-C"
            "fastfetch"
          ];
        };
      };
    };
  };

}
