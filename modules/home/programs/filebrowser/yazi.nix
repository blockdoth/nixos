{
  config,
  lib,
  ...
}:
let
  module = config.modules.programs.filebrowser.yazi;
in
{
  config = lib.mkIf module.enable {
    programs.yazi = {
      enable = true;
      settings.yazi = ''
        [mgr]
        show_hidden = true
      '';
    };
  };
}
