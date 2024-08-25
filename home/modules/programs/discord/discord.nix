{ pkgs, config, lib, ... }:
{  
  options = {
    modules.programs.discord.enable = lib.mkEnableOption "Enables discord";
  };

  config = lib.mkIf config.modules.programs.discord.enable {
    home.packages = with pkgs; [
      vesktop
    ];
  };
}
    
