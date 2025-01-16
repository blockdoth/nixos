{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ ./git.nix ];

  options = {
    modules.core.utils.cli.enable = lib.mkEnableOption "Enables cli utils";
  };
  config = lib.mkIf config.modules.core.utils.cli.enable {
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
    ];
  };

}
