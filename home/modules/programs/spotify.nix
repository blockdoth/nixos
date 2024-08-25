{ pkgs, config, lib, ... }:
{  
  options = {
    modules.programs.spotify.enable = lib.mkEnableOption "Enables spotify";
  };

  config = lib.mkIf config.modules.programs.spotify.enable {
    home.packages = with pkgs; [
      spotify
    ];
  };
}
    
