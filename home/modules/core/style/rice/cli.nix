{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.core.style.rice.cli;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      cmatrix
      fortune
      cowsay
      pipes
      cbonsai
      tty-clock
      lolcat
      figlet
      mesa-demos
    ];
  };
}
