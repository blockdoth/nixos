{
  config,
  lib,
  ...
}:
let
  module = config.modules.core.shell.zoxide;
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
