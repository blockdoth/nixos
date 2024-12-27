{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    modules.core.terminal.ghostty.enable = lib.mkEnableOption "Enables ghostty";
  };

  config =
    let
      stylix = config.lib.stylix;
      toStr = var: builtins.toString var;
    in
    lib.mkIf config.modules.core.terminal.ghostty.enable {
      home.packages = with pkgs; [ inputs.ghostty.packages.x86_64-linux.default ];

      xdg.configFile."ghostty/config".text = ''
        window-decoration = false
        confirm-close-surface = false
        term = xterm-256color
        resize-overlay = never
        clipboard-trim-trailing-spaces = true
        font-size = ${toStr config.stylix.fonts.sizes.terminal} 
        background-opacity = ${toStr config.stylix.opacity.terminal} 
        window-padding-x = 10
        window-padding-y = 10
        background = #${stylix.colors.base00}
        foreground = #${stylix.colors.base05}
        selection-foreground = #${stylix.colors.base05} 
        selection-background = #${stylix.colors.base02}     
        keybind = super+shift+e=increase_font_size
        keybind = super+shift+q=decrease_font_size
        keybind = super+shift+w=reset_font_size
        keybind = super+shift+s=new_split
        keybind = super+shift+d=close_surface
        keybind = super+shift+e=equalize_splits
      '';
    };

}
