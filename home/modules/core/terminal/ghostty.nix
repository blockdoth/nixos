{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.core.terminal.ghostty.enable = lib.mkEnableOption "Enables ghostty";
  };

  config = lib.mkIf config.modules.core.terminal.ghostty.enable {
    home.packages = with pkgs; [ inputs.ghostty.packages.x86_64-linux.default ];
    # home.sessionVariables = {
    #   TERMINAL = "alacritty";
    # };

  };

}
