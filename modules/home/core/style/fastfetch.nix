{
  config,
  lib,
  ...
}:
let
  module = config.modules.core.style.rice.cli;
in
{
  config = lib.mkIf module.enable {
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
  };
}
