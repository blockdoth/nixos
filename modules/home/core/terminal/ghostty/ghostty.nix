{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.core.terminal.ghostty;
  stylix = config.lib.stylix;
  toStr = var: builtins.toString var;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [ inputs.ghostty.packages.x86_64-linux.default ];

    xdg.configFile."ghostty/config".text = ''
      window-decoration = false
      confirm-close-surface = false
      focus-follows-mouse = true
      term = xterm-256color
      resize-overlay = never
      gtk-single-instance = true
      clipboard-trim-trailing-spaces = true
      font-size = ${toStr config.stylix.fonts.sizes.terminal} 
      background-opacity = ${toStr config.stylix.opacity.terminal} 
      unfocused-split-opacity=0.9
      window-padding-x = 10
      window-padding-y = 10
      font-feature=-calt
      font-feature=-liga
      font-feature=-dlig
      keybind = ctrl+s=new_split:right
      keybind = ctrl+a=new_split:down
      keybind = ctrl+d=close_surface
      keybind = ctrl+e=equalize_splits
      custom-shader-animation=true
    '';
  };
}
