{
  pkgs,
  config,
  lib,
  inputs,
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

    services.pihole-ftl = {
      enable = true;
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
