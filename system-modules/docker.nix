{ config, lib, ... }:
{
  options = {
    system-modules.docker.enable = lib.mkEnableOption "Enables docker";
  };

  config = lib.mkIf config.system-modules.docker.enable {

    virtualisation = {
      docker.enable = true;
      docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
