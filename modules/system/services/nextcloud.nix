{
  config,
  lib,
  ...
}:
let
  module = config.system-modules.services.nextcloud;
  domain = config.system-modules.secrets.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.nextcloud = {
      enable = true;
      configureRedis = true;
      hostName = "localhost";
      config = {
        trustedProxies = [ "127.0.0.1" ];
        adminpassFile = "/etc/nextcloud";
        dbtype = "sqlite";
      };
    };
    services.nginx.enable = false; # Since nextcloud uses nginx as webserver

    services.phpfpm.pools.nextcloud.settings = {
      "listen.owner" = config.services.caddy.user;
      "listen.group" = config.services.caddy.group;
    };
    users.users.caddy.extraGroups = [ "nextcloud" ];

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "nextcloud";
          port = config.services.nextcloud.port;
        }
      ];
      observability.healthchecks.endpoints = [
        {
          name = "Nextcloud";
          url = "https://nextcloud.${domain}";
        }
      ];
    };
  };
}
