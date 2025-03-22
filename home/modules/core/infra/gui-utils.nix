{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.infra.gui-utils;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      qimgv
      vlc
      xorg.xeyes # To detect if wayland vs xwayland
      xorg.xev # Check keybinds
      gparted # partitioning
      zathura # pdf viewer
      waypipe # display forwarding
      qdirstat
    ];
  };

}
