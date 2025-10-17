{
  pkgs,
  config,
  lib,
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
