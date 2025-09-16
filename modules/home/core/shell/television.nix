{
  pkgs,
  config,
  lib,
  hostname,
  ...
}:
let
  module = config.modules.core.shell.television;
in
{
  config = lib.mkIf module.enable {
    programs.television = {
      enable = true;
      # enableFishIntegration = true;
    };
  };
}
