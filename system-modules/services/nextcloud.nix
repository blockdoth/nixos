{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.nextcloud.enable = lib.mkEnableOption "Enables nextcloud";
  };

  config =
    let
      domain = config.system-modules.services.domains.homelab;
    in
    lib.mkIf config.system-modules.services.nextcloud.enable {
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

      services.caddy = {
        virtualHosts."nextcloud.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString config.services.minecraft-servers.servers.minecraft_21.serverProperties.server-port}        
        '';
      };
    };
}
