{ pkgs, config, lib, ... }:
{
  options = {
    modules.programs.filebrowser.dolphin.enable = lib.mkEnableOption "Enables dolphin";
  };

  config = lib.mkIf config.modules.programs.filebrowser.dolphin.enable {
    home.packages = with pkgs; [
      dolphin
    ];
  };
}
    
