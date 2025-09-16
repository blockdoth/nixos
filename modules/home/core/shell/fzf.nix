{
  pkgs,
  config,
  lib,
  hostname,
  ...
}:
let
  module = config.modules.core.shell.fzf;
in
{
  config = lib.mkIf module.enable {
    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
