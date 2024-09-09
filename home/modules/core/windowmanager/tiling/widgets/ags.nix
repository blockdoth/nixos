{ pkgs, config, lib, ... }:
{
  options = {
   modules.core.windowmanager.tiling.widgets.ags.enable = lib.mkEnableOption "Enables ags";
  };

  config = lib.mkIf config.modules.core.windowmanager.tiling.widgets.ags.enable {
    # programs.ags = {
    #   enable = true;
    
    # };
  };
}
