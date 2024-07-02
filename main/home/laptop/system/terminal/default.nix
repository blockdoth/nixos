_: let
  catppuccin = import ./catppuccin.nix;
in {
  programs.alacritty = {
    enable = true;
    settings = {
      inherit (catppuccin) colors;
      cursor = {
        style = {
          blinking = "Never";
        };
      };
      font = {
        size = 16;
        normal = {
          family = "Fira Mono Nerd Font";
          style = "Medium Italic";
        };
        bold = {
          family = "Fira Mono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "Fira Mono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "Fira Mono Nerd Font";
          style = "Bold Italic";
        };
        offset = {
          x = 0;
          y = 0;
        };
        glyph_offset = {
          x = 0;
          y = 0;
        };
      };
      window = {
        opacity = 0.95;
        decorations = "none";
        padding = {
          x = 10;
          y = 10;
        };
      };
      keyboard.bindings = [
        #{
        #  key = "V";
        #  mods = "Control|Shift";
        #  action = "Paste";
        #}
      ];
    };
  };
}
