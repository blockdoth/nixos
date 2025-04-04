{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.core.windowmanager.tiling.widgets.ags;
in
{
  imports = [ inputs.ags.homeManagerModules.default ];
  config = lib.mkIf module.enable {
    programs.ags = {
      enable = true;
    };
  };
}
