{
  config,
  lib,
  ...
}:
let
  module = config.modules.core.terminal.ghostty;
  toStr = var: toString var;
in
{
  config = lib.mkIf module.enable {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        window-decoration = false;
        confirm-close-surface = false;
        focus-follows-mouse = true;
        term = "xterm-256color";
        resize-overlay = "never";
        gtk-single-instance = true;
        clipboard-trim-trailing-spaces = true;
        font-size = "${toStr config.stylix.fonts.sizes.terminal}";
        background-opacity = "${toStr config.stylix.opacity.terminal}";
        unfocused-split-opacity = 0.9;
        window-padding-x = 10;
        window-padding-y = 10;
        font-feature = [
          "-calt"
          "-liga"
          "-dlig"
        ];
        keybinds = [
          "ctrl+s=new_split:right"
          "ctrl+a=new_split:down"
          "ctrl+d=close_surface"
          "ctrl+e=equalize_splits"
        ];
        custom-shader-animation = true;
      };
    };
  };
}
