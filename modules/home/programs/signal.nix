{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.signal;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      signal-desktop
    ];
  };
}
