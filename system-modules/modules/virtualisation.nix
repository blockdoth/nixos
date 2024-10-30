{ config, lib, ... }:
{
  options = {
    system-modules.virtualisation.enable = lib.mkEnableOption "Enables virtualisation";
  };

  config = lib.mkIf config.system-modules.virtualisation.enable {
    virtualisation = {
      docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}