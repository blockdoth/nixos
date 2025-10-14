{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.dev.zed;
in
{
  config = lib.mkIf module.enable {

    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
      userSettings = {

      };
      extensions = [ ];
    };
  };
}
