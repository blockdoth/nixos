{ config, lib, ... }:

let
  module = config.system-modules.common.nfs;
in
{
  # NFS client mounts
  config = {
    fileSystems = lib.mkIf module.client.enable (
      lib.genAttrs module.client.mounts (mount: {
        value = {
          "/mnt/${mount.name}" = {
            device = "${mount.address}:/srv/${mount.name}";
            fsType = "nfs";
            options = [
              "rw"
              "hard"
              "intr"
            ];
          };
        };
      })
    );

    services.nfs = lib.mkIf module.server.enable {
      server = {
        enable = true;
        exports = module.server.exports; # TODO
      };
    };
  };
}
