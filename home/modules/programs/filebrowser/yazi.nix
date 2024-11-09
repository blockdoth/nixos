{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.programs.filebrowser.yazi.enable = lib.mkEnableOption "Enables yazi";
  };

  config = lib.mkIf config.modules.programs.filebrowser.yazi.enable {

    programs.yazi = {
      enable = true;
      settings.yazi = ''
        [manager]
        show_hidden = true
      '';
    };
  };
}
