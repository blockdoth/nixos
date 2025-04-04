{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.anki;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      anki
    ];
  };
}
