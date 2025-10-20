{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.core.style.rice.gui;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      inputs.activate-linux.packages.${pkgs.system}.activate-linux
      mesa-demos
    ];
  };
}
