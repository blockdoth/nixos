{
  config,
  lib,
  ...
}:
let
  module = config.modules.core.shell.command-not-found;
in
{
  config = lib.mkIf module.enable {
    programs.command-not-found = {
      enable = true;
    };
  };
}
