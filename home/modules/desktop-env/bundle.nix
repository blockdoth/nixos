{config, lib, pkgs, ...}:
{
  options = {
    desktop-env = {
      gui.enable = lib.mkOption { type = lib.types.bool; default = false; };
    };
  };

  config = 
    mkMerge [ 
      {
        imports = [
          ./shell
          ./terminal
        ];
      }
      (mkIf (!config.desktop-env.gui.enable) { 
        imports = mkMerg [
          ./filebrowser
          ./compositor
        ];
      })
    ];
}
