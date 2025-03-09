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
    display.x11.enable = false;
    services = {
      syncthing.enable = true;
      atuin.enable = false;
      headscale.enable = false;
      immich.enable = false;
      grafana.enable = false;
      prometheus.enable = false;
      promtail.enable = false;
      loki.enable = false;
      acme.enable = false;
      ddns.enable = false;
      iss-piss-stream.enable = false;
      linkwarden.enable = false;
      mediaserver.enable = false;
    };
  };

  networking.hostName = "desktop";
  system.stateVersion = "24.05"; # Did you read the comment?
}
