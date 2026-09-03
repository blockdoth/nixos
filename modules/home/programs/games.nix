{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.programs.games;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      beyond-all-reason
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
