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
    users.penger.enable = true;
    ssh.enable = true;
    docker.enable = true;
    services = {
      atuin.enable = true;
      headscale.enable = true;
      immich.enable = true;
      grafana.enable = true;
      prometheus.enable = true;
      promtail.enable = true;
      loki.enable = true;
      acme.enable = true;
      ddns.enable = true;
      iss-piss-stream.enable = true;
      caddy.enable = true;
      minecraftserver.enable = true;
      syncthing.enable = true;
      nextcloud.enable = false;
      blocky.enable = false;
      mediaserver.enable = false;
      anki-sync.enable = true;
    };
    tailscale = {
      enable = true;
      exit-node = true;
    };
  };

  networking.hostName = "nuc";

  system.stateVersion = "24.05"; # Did you read the comment?
}
