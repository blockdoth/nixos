{
  lib,
  config,
  ...
}:
let
  module = config.modules.windowmanager.gnome;
in
{
  config = lib.mkIf module.enable {

  };
}
