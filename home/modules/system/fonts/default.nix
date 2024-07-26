{ pkgs, config, lib, ... }:
{
  options = {
    custom-fonts.enable = lib.mkEnableOption "Enables custom fonts";
  }; 
  
  config = lib.mkIf config.custom-fonts.enable {
    fonts.fontconfig.enable = true; 
    home.packages = with pkgs; [
      font-manager
      jetbrains-mono
      font-awesome
      powerline-fonts
      powerline-symbols
      # nerd fonts
      # (nerdfonts.override { fonts = [ 
      #   # "NerdFontsSymbolsOnly"

      #   ]; 
      # })
    ];
  };
}