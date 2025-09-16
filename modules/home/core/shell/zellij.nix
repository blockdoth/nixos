{
  config,
  lib,
  ...
}:
let
  module = config.modules.core.shell.zellij;
in
{
  config = lib.mkIf module.enable {
    programs.zellij = {
      enable = true;
      enableFishIntegration = true;
      exitShellOnExit = false;
    };
  };
}
