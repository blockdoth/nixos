{ pkgs, config, lib, ... }:
{

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
        "terminalfont"
        "cpu"
        "gpu"
        "memory"
        "break"
        "colors"
      ];
    };
  };
}