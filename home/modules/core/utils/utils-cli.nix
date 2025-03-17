{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.utils.cli;
in
{
  imports = [ ./git.nix ];

  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      jq
      fd
      unzip
      ripgrep
      fzf
      htop
      btop
      bottom
      powertop
      zip
      ffmpeg
      bc
      micro
      entr
      tmux
      comma
      rclip
      systemctl-tui
      nix-tree
      gdu
      nix-search
      file
      cron
    ];
  };
}
