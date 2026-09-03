{
  inputs,
  config,
  lib,
  ...
}:
let
  module = config.system-modules.core.impermanence;
in
{
  imports = [
    inputs.disko.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    inputs.preservation.nixosModules.default
  ];

  config = lib.mkIf module.enable {

    preservation = {
      enable = true;

      preserveAt."/persistent" = {
        directories = [
          "/etc/nixos"
          "/var/log"
          "/var/lib/bluetooth"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/lib/systemd/timers"
          "/etc/NetworkManager/system-connections"
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
        ];

        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
        ];

        # Preserve user files
        # users.yurii = {
        #   directories = [
        #     ".ssh"
        #     ".mozilla"
        #   ];
        #
        #   files = [
        #
        #   ];
        # };

      };
    };
  };
}
