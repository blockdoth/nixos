{ pkgs, config, lib, ...}:
{
  options = {
    rice.enable = lib.mkEnableOption "Enables rice cli programs";
  };

  config = lib.mkIf config.rice.enable {
    home.packages = with pkgs; [
      cmatrix
      fortune
      cowsay
      neofetch
      pipes
      cava
    ];
  };
}
