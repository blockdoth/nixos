{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = config.system-modules.core.tailscale;
  impermanence = config.system-modules.core.impermanence;
  enableGui = config.system-modules.presets.gui.enable;
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

    systemd.services.tailscaled-autoconnect = {
      wantedBy = lib.mkForce (if enableGui then [ "graphical.target" ] else [ "multi-user.target" ]);
    };

    networking.firewall = {
      trustedInterfaces = [
        config.services.tailscale.interfaceName
      ];
      allowedUDPPorts = [
        53
        config.services.tailscale.port
      ];
    };

    environment.persistence = lib.mkIf impermanence.enable {
      "/persist/backup".directories = [ "/var/lib/tailscale" ];
    };
  };
}
