{ config, lib, ... }:
{
  options = {
    virtualisation.enable = lib.mkEnableOption "Enables virtualisation";
  };

  config = lib.mkIf config.virtualisation.enable {
    virtualisation = {
      docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}