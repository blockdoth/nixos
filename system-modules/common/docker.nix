{ config, lib, ... }:
let
  module = config.system-modules.common.docker;
in
{

  config = lib.mkIf module.enable {
    virtualisation = {
      docker.enable = true;
      docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
