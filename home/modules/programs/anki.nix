{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    modules.programs.anki.enable = lib.mkEnableOption "Enables anki";
  };

  config = lib.mkIf config.modules.programs.anki.enable {
    home.packages = with pkgs; [
      anki
    ];
  };
}
