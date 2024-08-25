{ pkgs, config, lib, ... }:
{
  options = {
    modules.core.style.theme.stylix.enable = lib.mkEnableOption "Enables stylix";
  }; 
  
  config = lib.mkIf config.modules.core.style.theme.stylix.enable {
    
  };
}