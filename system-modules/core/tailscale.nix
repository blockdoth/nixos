{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = config.system-modules.core.tailscale;
in
{
  config = lib.mkIf module.enable {
    sops.secrets.tailscale-auth-key = { };

    environment.systemPackages = with pkgs; [
      tailscale
    ];

    services.tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale-auth-key.path;
      useRoutingFeatures = if module.exit-node then "server" else "client";
    };

    networking.firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
