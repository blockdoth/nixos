{ pkgs, config, lib, inputs, ... }:
{
  imports = [ inputs.ags.homeManagerModules.default ];

  options = {
   modules.core.windowmanager.tiling.widgets.ags.enable = lib.mkEnableOption "Enables ags";
  };

  config = lib.mkIf config.modules.core.windowmanager.tiling.widgets.ags.enable {
    programs.ags = {
      enable = true;
    
    };
  };
}
