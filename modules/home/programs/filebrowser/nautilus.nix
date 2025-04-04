{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.programs.filebrowser.nautilus;
in
{
  config = lib.mkIf module.enable {
    #TODO figure out why icons get weird
    home.packages = with pkgs; [
      nautilus
    ];
  };
}
