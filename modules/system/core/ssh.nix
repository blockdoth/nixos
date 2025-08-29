{ config, lib, ... }:
let
  module = config.system-modules.core.ssh;
in
{
  config = lib.mkIf module.enable {
    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PasswordAuthentication = false;
      };
    };
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
