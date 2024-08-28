{ pkgs, config, lib, inputs, ... }:
{  
  options = {
    modules.programs.minecraft.enable = lib.mkEnableOption "Enables minecraft";
  };

  config = lib.mkIf config.modules.programs.minecraft.enable {
    home.packages = with pkgs; [
      (prismlauncher.override { 
        withWaylandGLFW = true;
        jdks = [ jdk17 jdk21]; 
        }
      )
    ];
  };
}
    
