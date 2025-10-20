{
  config,
  pkgs,
  lib,
  ...
}:
let
  module = config.system-modules.common.nfs;
  hostname = config.system-modules.core.networking.hostname;
in
{
  config = lib.mkIf module.enable {
    fileSystems."/mnt/${hostname}" = {
      device = "nuc:/srv/${hostname}";
      fsType = "nfs";
      options = [
        "rw"
        "hard"
        "intr"
      ];
    };
  };
}
