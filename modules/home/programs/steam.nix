{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.steam;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      # steam
    ];
  };
}
