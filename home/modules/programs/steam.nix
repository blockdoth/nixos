{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    modules.programs.steam.enable = lib.mkEnableOption "Enables steam";
  };

  config = lib.mkIf config.modules.programs.steam.enable {
    home.packages = with pkgs; [
      # steam
    ];
  };
}
