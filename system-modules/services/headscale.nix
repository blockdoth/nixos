{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.headscale.enable = lib.mkEnableOption "Enables headscale";
  };

  config =
    let
      domain = "insinuatis.ddns.net";
    in
    lib.mkIf config.system-modules.services.headscale.enable {
      services.headscale = {
        enable = true;
        address = "127.0.0.1";
        port = 8085;
        user = "penger";
        settings = {
          server_url = "https://${domain}";
          dns = {
            base_domain = "${domain}";
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
          derp.server = {
            enable = true;
            region_id = 999;
            stun_listen_addr = "0.0.0.0:3478";
          };
        };
      };

      services.caddy = {
        enable = true;
        virtualHosts."${domain}".extraConfig = ''
          reverse_proxy http://localhost:{config.services.headscale.port}        
        '';
      };

      # security.acme.certs.${domain} = {
      #   dnsProvider = "porkbun";
      # };

      networking.firewall = {
        # DERP port (https://tailscale.com/kb/1082/firewall-ports)
        allowedUDPPorts = [ 3478 ];
        trustedInterfaces = [ config.services.tailscale.interfaceName ];
      };
    };
}
