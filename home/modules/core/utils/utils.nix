{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ ./git.nix ];

  options = {
    modules.core.utils.base.enable = lib.mkEnableOption "Enables base utils";
  };
  config = lib.mkIf config.modules.core.utils.base.enable {
    home.packages = with pkgs; [
      jq
      fd
      unzip
      ripgrep
      fzf
      imagemagick
      htop
      btop
      bottom
      qimgv
      vlc
      xorg.xeyes # To detect if wayland vs xwayland
      powertop
      zip
      ffmpeg
      xorg.xev # Check keybinds
      gparted # partitioning
      zathura # pdf viewer
      bc
      micro
      entr
    ];
  };

}
