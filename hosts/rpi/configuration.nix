{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../../modules/system/options.nix
    ./hardware.nix
  ];

  system-modules = {
    users.mowie.enable = true;
    presets.defaults.enable = false;
    core = {
      env.enable = true;
      localization.enable = true;
      nix-config.enable = true;
      secrets.enable = true;
      tailscale.enable = true;
      ssh.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [

  ];

  boot = {
    consoleLogLevel = 7;
    kernelPackages = pkgs.linuxPackages_rpi3;
    kernelParams = [
      "dwc_otg.lpm_enable=0"
      "console=ttyAMA0,115200"
      "rootwait"
      "elevator=deadline"
    ];
    kernelModules = [
      "bcm2835-v4l2"
    ];
    loader = {
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
      generationsDir.enable = false;
      raspberryPi = {
        enable = true;
        uboot.enable = true;
        version = 2;
        firmwareConfig = ''
          start_x=1
          gpu_mem=256
        '';
      };
    };
  };

  systemd.services.btattach = {
    before = [ "bluetooth.service" ];
    after = [ "dev-ttyAMA0.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
    };
  };

  nixpkgs.config.platform = lib.systems.platforms.raspberrypi2;
  powerManagement.enable = false;

  # https://blog.janissary.xyz/posts/nixos-install-custom-image
  networking = {
    hostName = "rpi";
    wireless = {
      enable = true;
      networks = {
        "YES!Delft" = {
          psk = "1megqu#GDSA5sst1Dswex2";
        };
      };
    };
    # interfaces.end0 = {
    #   ipv4.addresses = [
    #     {
    #       address = "192.168.1.42";
    #       prefixLength = 24;
    #     }
    #   ];
    # };
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
