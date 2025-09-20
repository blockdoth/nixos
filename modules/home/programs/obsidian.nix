{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.obsidian;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
