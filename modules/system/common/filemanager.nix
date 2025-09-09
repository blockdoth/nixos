{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = config.system-modules.common.filemanager;
in
{

  config = lib.mkIf module.enable {
    programs = {
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-media-tags-plugin
          thunar-volman
        ];
      };
      xfconf.enable = true;
      file-roller.enable = true;
      dconf.enable = true;
    };
    services = {
      gvfs.enable = true;
      tumbler.enable = true;
    };

    environment.systemPackages = with pkgs; [
      xdg-utils
    ];
  };
}
