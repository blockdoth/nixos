{
  config,
  lib,
  ...
}:
let
  module = config.system-modules.core.grub;
in
{
  config = lib.mkIf module.enable {
    systemd.enableEmergencyMode = false;
    boot = {
      supportedFilesystems = [ "ntfs" ];
      loader = {
        systemd-boot = {
          enable = false;
          editor = false;
        };
        timeout = 0; # boot menu will only how up if any key is pressed

        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          # useOSProber = true;
          configurationLimit = 5;
        };
      };
      # https://wiki.archlinux.org/title/Silent_boot

      kernelParams = [
        "quiet"
        "loglevel=3"
        "splash"
        "udev.log_priority=3"
        "vt.global_cursor_default=0"
        "rd.systemd.show_status=false"
      ];
      consoleLogLevel = 0;
      # https://github.com/NixOS/nixpkgs/pull/108294
      initrd.verbose = false;

      blacklistedKernelModules = [
        "joydev"
        "tiny_power_button"
        "mousedev"
        "edac_core"
        "edac_mce_amd"
        "mac_hid"
        "efi_pstore"
        "dmi_sysfs"
        "wmi_bmof"
        "ee1004"
      ];
    };
  };
}
