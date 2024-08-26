{ pkgs, config, lib, ... }:
{
  options = {
    modules.dev.editors.jetbrains.enable = lib.mkEnableOption "Enables jetbrains idea's";
  };

  config = lib.mkIf config.modules.dev.editors.jetbrains.enable {
    home.packages = with pkgs; [
      jetbrains.clion
      jetbrains.webstorm
      jetbrains.pycharm-community
      jetbrains.idea-ultimate
      jetbrains.rust-rover
    ];

    
  };
}
