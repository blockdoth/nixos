{ config, lib, ... }:
{
  options = {
    system-modules.crosscompilation.enable = lib.mkEnableOption "Enables cross compilation";
  };

  config = lib.mkIf config.system-modules.crosscompilation.enable {
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

}