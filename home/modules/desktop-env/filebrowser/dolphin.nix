{ pkgs, config, lib, ... }:
{
  options = {
    filebrowser.dolphin.enable = lib.mkEnableOption "Enables dolphin";
  };

  config = lib.mkIf config.filebrowser.dolphin.enable {
    home.packages = with pkgs; [
      dolphin
    ];
  };
}
    
