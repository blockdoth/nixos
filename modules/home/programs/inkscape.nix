{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.programs.inkscape;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      inkscape
    ];
  };
}
