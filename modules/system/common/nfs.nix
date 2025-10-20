{
  config,
  pkgs,
  lib,
  hostname,
  ...
}:
let
  module = config.system-modules.common.nfs;
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      nfs-utils
    ];

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
