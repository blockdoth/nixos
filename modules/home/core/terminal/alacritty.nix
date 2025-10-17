{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.terminal.alacritty;
in
{
  config = lib.mkIf module.enable {
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

        keyboard.bindings = [
          {
            key = "Return";
            mods = "Control|Shift";
            action = "SpawnNewInstance";
          }
          {
            key = "Plus";
            mods = "Control";
            action = "IncreaseFontSize";
          }
          {
            key = "Minus";
            mods = "Control";
            action = "DecreaseFontSize";
          }
        ];

        terminal.shell = {
          program = "fish";
        };
      };
    };
  };

}
