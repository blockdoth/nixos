{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.programs.gimp;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      gimp3
    ];
  };
}
