{ inputs, config, pkgs, lib, ... }:
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
  };

  networking.hostName = "penger";

  system.stateVersion = "24.05"; # Did you read the comment?
}
