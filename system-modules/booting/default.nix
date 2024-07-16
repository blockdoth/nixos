{  config, lib, ... }:
{
  options = {
    booting.enable = lib.mkEnableOption "Enables booting";
  };

  config = lib.mkIf config.booting.enable {
    systemd.enableEmergencyMode = false;
    boot = {
      supportedFilesystems = ["ntfs"];
      loader = {
        systemd-boot = {
          enable = false;
          editor = false;
        };
        timeout = 10;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          useOSProber = true;
          configurationLimit = 5;
        };
      };
    };
  };
}