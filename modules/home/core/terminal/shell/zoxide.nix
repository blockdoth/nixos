{
  pkgs,
  config,
  lib,
  hostname,
  ...
}:
let
  module = config.modules.core.terminal.shell.zoxide;
in
{
  config = lib.mkIf module.enable {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}
