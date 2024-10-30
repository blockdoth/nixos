{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ./hardware.nix 
    ../../system-modules
  ];

  system-modules = {
    common.enable = true;
    users.headless.enable = true;
    ssh.enable = true;
    grub.enable = false;
  };

  boot = {
    consoleLogLevel = 7;
    kernelPackages = pkgs.linuxPackages_rpi2;
    kernelParams = [
      "dwc_otg.lpm_enable=0"
      "console=ttyAMA0,115200"
      "rootwait"
      "elevator=deadline"
    ];
    loader = {
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
      generationsDir.enable =false;
      raspberryPi = {
        enable = true;
        version = 2;
      };
    };
  };

  nixpkgs.config.platform = lib.systems.platforms.raspberrypi2;
  powerManagement.enable = false;

  # https://blog.janissary.xyz/posts/nixos-install-custom-image
  networking = {
    hostName = "rpi";
    interfaces.end0 = {
      ipv4.addresses = [{
        address = "192.168.1.42";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.1.1"; # or whichever IP your router is
      interface = "end0";
    };
    nameservers = [
      "192.168.1.1" # or whichever DNS server you want to use
    ];
  };
  
  system.stateVersion = "24.05"; # Did you read the comment?
}
