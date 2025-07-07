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
    programs.shyfox = {
      enable = true;
      sideberyConfigPath = ./sidebery-config.json;
    };
  };
}
