{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../system-modules
  ];

  system-modules = {
    gui.enable = true;
    audio.enable = true;
    gaming.enable = true;
    users.blockdoth.enable = true;
    tailscale.enable = true;
    ssh.enable = true;
    services = {
      headscale.enable = false;
      atuin.enable = true;
      iss-piss-stream.enable = false;
      grafana.enable = false;
      prometheus.enable = false;
    };
  };

  networking.hostName = "desktop";
  system.stateVersion = "24.05"; # Did you read the comment?
}
