{ config, lib, ... }:

let
  module = config.system-modules.common.nfs;
  hostname = config.system-modules.core.networking.hostname;
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
        exports = [ ]; # TODO
      };
    };
  };
}
