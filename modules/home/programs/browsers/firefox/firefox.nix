{
  pkgs,
  config,
  lib,
  system,
  inputs,
  ...
}:
let
  module = config.modules.programs.browsers.firefox;
  defaultProfile = "default";
in
{
  imports = [
    inputs.shyfox.homeManagerModules.shyfox

  ];

  config = lib.mkIf module.enable {
    # https://github.com/blockdoth/ShyFox
    # sideberry is still not fully reproducible but I give up for now
    programs.shyfox = {
      enable = true;
      sideberyConfigPath = ./sidebery-config.json;
      profile = "test";
    };
  };
}
