{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.network.reverse-proxy.nginx;
  domain = config.system-modules.services.network.domains.homelab;
  certPath = "/var/lib/acme/${domain}/fullchain.pem";
  keyPath = "/var/lib/acme/${domain}/privkey.pem";
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      nginx
    ];

    services.nginx = {
      enable = true;
    };
  };
}
