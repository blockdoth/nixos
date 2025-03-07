{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    modules.programs.llms.enable = lib.mkEnableOption "Enables llms";
  };

  config = lib.mkIf config.modules.programs.llms.enable {
    home.packages = with pkgs; [
      jan
    ];
  };
}
