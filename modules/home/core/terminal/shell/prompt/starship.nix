{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.terminal.shell.prompt.starship;
in
{
  config = lib.mkIf module.enable {
    programs.starship = {
      enable = true;
      enableTransience = false;
      settings = {
        scala = {
          detect_folders = [
            "!.config"
            ".metals"
          ];
        };
      };
    };
  };
}
