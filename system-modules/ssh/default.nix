{ config, lib, ... }:
{
  options = {
    ssh.enable = lib.mkEnableOption "Enables ssh";
  };

  config = lib.mkIf config.ssh.enable {
    services.openssh.enable = true;

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 22 ];
    };
  };

}