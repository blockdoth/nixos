{
  config,
  lib,
  ...
}:
let
  module = config.modules.core.shell.pay-respects;
in
{
  config = lib.mkIf module.enable {
    programs.pay-respects = {
      enable = true;
      # enableFishIntegration = true;
    };
  };
}
