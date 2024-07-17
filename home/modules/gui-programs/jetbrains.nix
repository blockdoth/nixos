{ pkgs, config, lib, ... }:
{
  options = {
    jetbrains.enable = lib.mkEnableOption "Enables jetbrains idea's";
  };

  config = lib.mkIf config.jetbrains.enable {
    home.packages = with pkgs; [
      jetbrains.clion
      jetbrains.webstorm
      jetbrains.pycharm-community
      jetbrains.idea-ultimate
    ];
  };

}
