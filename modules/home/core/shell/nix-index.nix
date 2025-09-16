{
  config,
  lib,
  ...
}:
let
  module = config.modules.core.shell.nix-index;
in
{
  config = lib.mkIf module.enable {
    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
