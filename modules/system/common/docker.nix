{ config, lib, ... }:
let
  module = config.system-modules.common.docker;
in
{

  config = lib.mkIf module.enable {
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = false;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    };
  };
}
