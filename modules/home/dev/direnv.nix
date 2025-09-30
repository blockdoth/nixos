{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.dev.direnv;
in
{
  config = lib.mkIf module.enable {
    home.sessionVariables = {
      DIRENV_WARN_TIMEOUT = "100h";
      DIRENV_LOG_FORMAT = ""; # disables direnv logs
    };
    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };
}
