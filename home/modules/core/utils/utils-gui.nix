{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ ./git.nix ];

  options = {
    modules.core.utils.gui.enable = lib.mkEnableOption "Enables gui utils";
  };
  config = lib.mkIf config.modules.core.utils.gui.enable {
    home.packages = with pkgs; [
      qimgv
      vlc
      xorg.xeyes # To detect if wayland vs xwayland
      xorg.xev # Check keybinds
      gparted # partitioning
      zathura # pdf viewer
    ];
  };

}
