{
  ...
}:
{

  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;

  disko.devices.disk.main = {
    device = "/dev/nvme0n1";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        esp = {
          name = "ESP";
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        swap = {
          size = "8G";
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };
        root = {
          name = "root";
          size = "100%";

          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];

            subvolumes = {
              "root" = {
                mountpoint = "/";
                mountOptions = [
                  "subvol=root"
                  "compress=zstd"
                  "noatime"
                ];
              };
              "nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "subvol=nix"
                  "compress=zstd"
                  "noatime"
                ];
              };

              "home" = {
                mountpoint = "/home";
                mountOptions = [
                  "subvol=home"
                  "compress=zstd"
                  "noatime"
                ];
              };

              "persist" = {
                mountpoint = "/persist";
                mountOptions = [
                  "subvol=persist"
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
