{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.system-modules.services.network.pihole;
  domain = config.system-modules.secrets.domains.homelab;
  port = 5125;
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      pihole-web
      pihole
      pihole-ftl
    ];

    services.resolved.enable = lib.mkForce false;

    networking.nameservers = [
      "127.0.0.1"
      "1.1.1.1"
    ];

    services.pihole-ftl = {
      enable = true;
      settings = {
        dns.upstreams = [
          "1.1.1.1"
          "9.9.9.9"
          "8.8.8.8"
        ];
      };
    };

    services.pihole-web = {
      enable = true;
      hostName = "pihole.${domain}";
      ports = [ "${builtins.toString port}" ];
    };

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "pihole";
          port = port;
          require-auth = true;
        }
      ];
      # TODO
      # observability.healthchecks.endpoints = [
      #   {
      #     name = "Pihole";
      #     url = "https://pihole.${domain}";
      #     endpoint = "/health";
      #   }
      # ];
    };

  };
}
