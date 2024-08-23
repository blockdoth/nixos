{ pkgs, config, lib, ... }:
{
  options = {
    filebrowser.yazi.enable = lib.mkEnableOption "Enables yazi";
  };

  config = lib.mkIf config.filebrowser.yazi.enable {

    programs.yazi = {
      enable = true;
      settings.yazi = 
      ''
        [manager]
        show_hidden = true
      '';
    };
  };
}
    
