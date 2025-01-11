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
    enable = true;
    users.penger.enable = true;
    ssh.enable = true;
    docker.enable = true;
    services.iss-piss-stream.enable = false;
    services.headscale.enable = true;
    tailscale.enable = true;
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
