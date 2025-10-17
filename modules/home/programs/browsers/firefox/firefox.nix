{
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.browsers.firefox;
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
      profile = "default";
    };
  };
}
