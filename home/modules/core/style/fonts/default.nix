{ pkgs, config, lib, ... }:
{
  options = {
    modules.core.style.fonts.enable = lib.mkEnableOption "Enables custom fonts";
  }; 
  
  config = lib.mkIf config.modules.core.style.fonts.enable {
    fonts.fontconfig.enable = true; 
    home.packages = with pkgs; [
      font-manager
      jetbrains-mono
      font-awesome
      powerline-fonts
      powerline-symbols
      dejavu_fonts
      (nerdfonts.override { 
        fonts = [ 
          "FiraCode" 
          "DroidSansMono" 
          "JetBrainsMono"
        ]; 
      })
    ];
  };
}