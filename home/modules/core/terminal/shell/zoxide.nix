{
  pkgs,
  config,
  lib,
  hostname,
  ...
}:
{
  options = {
    modules.core.terminal.shell.zoxide.enable = lib.mkEnableOption "Enables zoxide";
  };

  config = lib.mkIf config.modules.core.terminal.shell.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
