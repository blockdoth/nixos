{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.network.headscale;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.headscale = {
      enable = true;
      address = "127.0.0.1";
      port = 8085;
      user = "penger";
      settings = {
        server_url = "https://headscale.${domain}";
        metrics_listen_addr = "127.0.0.1:8095";
        dns = {
          base_domain = "local.com";
          magic_dns = true;
          behind_proxy = true;
          override_local_dns = true;
          nameservers.global = [
            "1.1.1.1"
            "9.9.9.9"
          ];
        };
        ip_prefixes = [
          "100.64.0.0/10"
        ];
        logtail.enabled = false;
        noise.private_key_path = "/var/lib/headscale/noise_private.key";
        # derp.server = {
        #   enable = true;
        # region_id = 999;
        # stun_listen_addr = "0.0.0.0:3478";
        # };
      };
    };

    services.caddy.virtualHosts."headscale.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${builtins.toString config.services.headscale.port}        
    '';

    system-modules.services.observability.gatus.endpoints = [
      {
        name = "Headscale";
        url = "https://headscale.${domain}/health";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];

    networking.firewall = {
      # DERP port (https://tailscale.com/kb/1082/firewall-ports)
      allowedUDPPorts = [ 3478 ];
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
    };
  };
}
