{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.programs.filebrowser.dolphin;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [ dolphin ];
  };
}
