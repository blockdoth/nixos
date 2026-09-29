{
  inputs,
  config,
  lib,
  ...
}:
let
  module = config.system-modules.common.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  config = lib.mkIf module.enable {

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/tailscale"
        "/var/lib/sops-nix"
      ];
      files = [
        "/etc/NetworkManager/system-connections"
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };

    boot.initrd.systemd = {
      enable = true;
      services.rollback = {
        description = "reset root";
        wantedBy = [ "initrd.target" ];

        # Before mounting the system root (/sysroot) during the early boot process
        before = [ "sysroot.mount" ];
        unitConfig = {
          Requires = [ "dev-nvme0n1p3.device" ];
          After = [ "dev-nvme0n1p3.device" ];
          DefaultDependencies = "no";
        };
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /mnt

          # We first mount the BTRFS root to /mnt
          # so we can manipulate btrfs subvolumes.
          mount -t btrfs -o subvolid=5 /dev/nvme0n1p3 /mnt
          # While we're tempted to just delete /root and create
          # a new snapshot from /root-blank, /root is already
          # populated at this point with a number of subvolumes,
          # which makes `btrfs subvolume delete` fail.
          # So, we remove them first.
          #
          # /root contains subvolumes:
          # - /root/var/lib/portables
          # - /root/var/lib/machines

          btrfs subvolume list -o /mnt/root |
            cut -f9 -d' ' |
            while read subvolume; do
              echo "deleting /$subvolume subvolume..."
              btrfs subvolume delete "/mnt/$subvolume"
            done

          echo "deleting /root subvolume..."
          btrfs subvolume delete /mnt/root

          echo "creating /root subvolume..."
          btrfs subvolume create /mnt/root
          # Once we're done rolling back to a blank snapshot,
          # we can unmount /mnt and continue on the boot process.
          umount /mnt
        '';
      };
    };

  };
}
