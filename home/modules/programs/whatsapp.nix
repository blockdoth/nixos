{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    modules.programs.whatsapp.enable = lib.mkEnableOption "Enables whatsapp";
  };

  config = lib.mkIf config.modules.programs.whatsapp.enable {
    home.packages = with pkgs; [
      whatsapp-for-linux
    ];
  };
}
