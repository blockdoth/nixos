{ pkgs, config, lib, inputs,... }:
{
  options = {
    modules.core.windowmanager.stacking.gnome.enable = lib.mkEnableOption "Enables gnome";
  };

  config = lib.mkIf config.modules.core.desktop.windowmanager.stacking.gnome.enable {

  };
}
