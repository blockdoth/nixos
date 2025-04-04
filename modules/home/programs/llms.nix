{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.llms;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      jan
    ];
  };
}
