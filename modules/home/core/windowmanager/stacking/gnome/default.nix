{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.core.desktop.windowmanager.stacking.gnome;
in
{
  config = lib.mkIf module.enable {
  };
}
