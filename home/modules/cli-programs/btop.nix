{ pkgs, config, lib, ... }:
{  
  options = {
    btop.enable = lib.mkEnableOption "Enables btop";
  };

  config = lib.mkIf config.btop.enable {
    home.packages = with pkgs; [
      btop
    ];
  };
}
    