{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.core.infra.cli-utils;
  tree_but_cooler = inputs.iss-piss-stream.packages.${pkgs.system}.default;
in
{
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
      tree
      tree_but_cooler
    ];
  };
}
