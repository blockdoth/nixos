{
  config,
  lib,
  pkgs,
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
        timeout = 10;
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
        "udev.log_priority=3"
        "vt.global_cursor_default=0"
        "rd.systemd.show_status=false"
      ];
      consoleLogLevel = 0;
      # https://github.com/NixOS/nixpkgs/pull/108294
      initrd.verbose = false;

      #disabled boot animations because it breaks booting
      # plymouth = {
      #   enable = false;
      #   theme = lib.mkForce "rings"; # Prevent conflict with stylix
      #   themePackages = with pkgs; [
      #     # By default we would install all themes
      #     (adi1090x-plymouth-themes.override { selected_themes = [ "rings" ]; })
      #   ];
      # };
    };
  };
}
