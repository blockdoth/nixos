{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    system-modules.tailscale.enable = lib.mkEnableOption "Enables tailscale";
  };

  config = lib.mkIf config.system-modules.tailscale.enable {
    environment.systemPackages = with pkgs; [ tailscale ];

    services.tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale-auth-key.path;
    };

    networking.firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

}
