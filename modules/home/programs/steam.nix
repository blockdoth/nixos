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
      # steam
      beyond-all-reason
    ];

  };
}
