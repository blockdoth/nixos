{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.programs.browsers.chromium;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      chromium
    ];
  };
}
