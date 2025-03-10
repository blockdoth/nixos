{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.programs.filebrowser.nautilus.enable = lib.mkEnableOption "Enables nautilus";
  };

  config = lib.mkIf config.modules.programs.filebrowser.nautilus.enable {
    home.packages = with pkgs; [
      nautilus
    ];
  };
}
