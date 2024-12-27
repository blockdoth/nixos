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
        term = xterm-256color
        font-size = ${toStr config.stylix.fonts.sizes.terminal} 
        background-opacity = ${toStr config.stylix.opacity.terminal} 
        window-padding-x = 10
        window-padding-y = 10
        background = #${stylix.colors.base00}
        selection-foreground = #${stylix.colors.base05} 
        selection-background = #${stylix.colors.base02}     
      '';
    };

}
