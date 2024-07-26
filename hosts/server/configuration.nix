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
  };

  networking.hostName = "server";

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 22 ];
    };
  };
  
  system.stateVersion = "24.05"; # Did you read the comment?
}
