{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    system-modules.tailscale = {
      enable = lib.mkEnableOption "Enables tailscale";
      exit-node = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf config.system-modules.tailscale.enable {
    environment.systemPackages = with pkgs; [ tailscale ];

    services.tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale-auth-key.path;
      useRoutingFeatures = if config.system-modules.tailscale.exit-node then "server" else "client";
    };

    networking.firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
