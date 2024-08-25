{ pkgs, config, lib, ... }:
{
  imports = [
    ./git.nix
  ];

  options = {
    modules.core.utils.base.enable = lib.mkEnableOption "Enables base utils";
  };
  config = lib.mkIf config.modules.core.utils.base.enable {
    home.packages = with pkgs; [
      jq
      fd
      ripgrep
      fzf
      imagemagick
      htop
      btop
    ];
  };

}
  
