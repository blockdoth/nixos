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
      blocky.enable = true;
    };
    tailscale = {
      enable = true;
      exit-node = true;
    };
  };

  networking = {
    hostName = "nuc";
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
        # 22
      ];
    };
  };
  system.stateVersion = "24.05"; # Did you read the comment?
}
