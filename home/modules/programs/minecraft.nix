{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.minecraft;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      (prismlauncher.override {
        # withWaylandGLFW = true;
        jdks = [
          jdk17
          jdk21
        ];
      })
    ];
  };
}
