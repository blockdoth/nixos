{config, lib, pkgs, ...}:
{
  imports = [
    ./desktop-env/bundle.nix
  ];

  options = {
    gui.enable = lib.mkOption { type = lib.types.bool; default = true; }; 
  };


  config = 
    mkMerge [ 
      {
        imports = [
          ./cli-programs
        ];
      }
      (mkIf (!config.desktop-env.gui.enable) { 
        imports = mkMerg [
          ./desk
          ./compositor
        ];
        desktop-env.gui = true;
      })
    ];
}
