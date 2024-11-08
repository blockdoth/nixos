{ pkgs, config, lib, inputs, ... }:
{  
  options = {
    modules.programs.zenbrowser.enable = lib.mkEnableOption "Enables zen browser";
  };

  config = lib.mkIf config.modules.programs.zenbrowser.enable {
    home.packages = with pkgs; [
      inputs.zen-browser.packages."${system}".specific
    ];

  };
}
    
