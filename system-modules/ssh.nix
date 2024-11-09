{ config, lib, ... }:
{
  options = {
    system-modules.ssh.enable = lib.mkEnableOption "Enables ssh";
  };

  config = lib.mkIf config.system-modules.ssh.enable {
    services.openssh.enable = true;

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 22 ];
    };
  };

}