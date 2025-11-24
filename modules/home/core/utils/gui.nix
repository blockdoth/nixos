{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.utils.gui;
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
      rclip # technically cli only, but need gui to be usefull
      mpv
    ];
  };

}
