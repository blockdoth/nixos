{ pkgs, config, lib, ... }:
{

  options = {
    custom-fonts.enable = lib.mkEnableOption "Enables custom fonts";
    custom-fonts.nerd.enable = lib.mkOption { type = lib.types.bool; default = false; }; 
  }; 
  config = lib.mkIf config.custom-fonts.enable {
    fonts.fontconfig.enable = true; 
    home.packages = with pkgs; [
      jetbrains-mono
      font-awesome
      # nerd fonts
    ] ++ lib.optionals config.custom-fonts.nerd.enable [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };
}