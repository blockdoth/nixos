{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = config.modules.dev.env;
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
    home.packages = with pkgs; [
      devenv
    ];
  };
}
