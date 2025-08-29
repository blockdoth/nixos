{ config, lib, ... }:
let
  module = config.system-modules.common.crosscompilation;
in
{
  config = lib.mkIf module.enable {
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    boot.kernelModules = [ "kvm-intel" ];
  };
}
