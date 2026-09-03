{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.core.style.cli;
  colors = config.lib.stylix.colors;
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
      hollywood
      onefetch
      inputs.activate-linux.packages.${pkgs.stdenv.hostPlatform.system}.activate-linux
    ];

    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "nixos";
          padding = {
            # right = 1;
          };
        };
        display = {
          size = {
            binaryPrefix = "si";
          };
          # color = "blue";
          separator = "  ";
        };
        modules = [
          "title"
          "separator"
          "os"
          "kernel"
          "host"
          "uptime"
          "packages"
          "terminal"
          "shell"
          "wm"
          "font"
          "cpu"
          "gpu"
          "memory"
          "break"
          "colors"
        ];
      };
    };
    programs.cava = {
      enable = true;
      settings = {
        general = {
          mode = "normal";
          framerate = 60;
        };
        # autosens = "1";
        input = {
          method = "pulse";
          source = "auto";
        };
        output = {
          method = "noncurses";
          channels = "mono";
          mono_option = "average";
          reverse = "1";
        };
        color = {
          gradient = 1;
          gradient_color_1 = "'#${colors.base0D}'";
          gradient_color_2 = "'#${colors.base0C}'";
        };
        eq = {
        };
        smoothing = {
          monstercat = "1";
          noise_reduction = 40;
        };
      };
    };
  };
}
