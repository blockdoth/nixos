{
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/system/options.nix
    ./hardware.nix
  ];

  system-modules = {
    users.blockdoth.enable = true;
    core.networking.hostname = "laptop";
    presets = {
      gui.enable = true;
      laptop.enable = true;
      # zenmode.enable = true;
    };
    common = {
      trackpad.enable = true;
      docker.enable = true;
      filemanager.enable = true;
      plymouth.enable = true;
      wireshark.enable = true;
      udev.enable = true;
    };
    display.x11.enable = false;
    services = {
      # servers.mowie.enable = true;
    };
  };
  nix.sshServe = {
    enable = true;
    trusted = true;
    write = true;
    keys = [
      (builtins.readFile ../desktop/id_ed25519.pub)
    ];
  };

  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [
    mesa
    libGL
    libdrm
    wayland
    egl-wayland
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
