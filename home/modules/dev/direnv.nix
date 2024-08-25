{ pkgs, config, lib, ... }:
{  
  options = {
    modules.dev.env.direnv.enable = lib.mkEnableOption "Enables direnvs";
  };

  config = lib.mkIf config.modules.dev.editors.jetbrains.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
    


