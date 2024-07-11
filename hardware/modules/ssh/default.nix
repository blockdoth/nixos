{ ... }:
{
  services.openssh.enable = true;

  networking.firewall = {
    firewall.enable = true;
    allowedTCPPorts = [ 80 443 22 ];
  };

}