{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.programs.whatsapp;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      zapzap
    ];
  };
}
