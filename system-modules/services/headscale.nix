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
        address = "0.0.0.0";
        port = 8080;
        user = "penger";
        settings = {
          server_url = "https://headscale.${domain}";
          dns = {
            base_domain = "https://tailnet.${domain}";
            magic_dns = true;
            domains = [ "headscale.${domain}" ];
            nameservers.global = [
              "1.1.1.1"
              "9.9.9.9"
            ];
          };
          ip_prefixes = [
            "100.64.0.0/10"
          ];
          logtail.enabled = false;
        };
      };

      services.caddy = {
        enable = true;
        virtualHosts."headscale.${domain}".extraConfig = ''
          reverse_proxy * 127.0.0.1:${toString config.services.headscale.port}
        '';
      };

      networking.firewall = {
        # DERP port (https://tailscale.com/kb/1082/firewall-ports)
        allowedUDPPorts = [ 3478 ];
        trustedInterfaces = [ config.services.tailscale.interfaceName ];
      };
    };
}
