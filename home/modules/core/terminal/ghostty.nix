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
    in
    lib.mkIf config.modules.core.terminal.ghostty.enable {
      home.packages = with pkgs; [ inputs.ghostty.packages.x86_64-linux.default ];

      xdg.configFile."ghostty/config".text = ''
        window-decoration = false
        term = xterm-256color

        window-padding-x = 10
        window-padding-y = 10
        background = #${stylix.colors.base00}
        foreground = #${stylix.colors.base05}
        selection-foreground = #${stylix.colors.base05} 
        selection-background = #${stylix.colors.base02}     
      '';
    };

}
