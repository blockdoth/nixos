{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.programs.blender;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      blender
    ];
  };
}
