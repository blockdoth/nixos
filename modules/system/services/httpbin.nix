{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.httpbin;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {

    services.go-httpbin = {
      enable = true;
      settings = {
        PORT = 4289;
      };
    };

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          subdomain = "httpbin";
          port = config.services.go-httpbin.settings.PORT;
        }
      ];
      observability.healthchecks.endpoints = [
        {
          name = "httpbin";
          url = "https://httpbin.${domain}";
        }
      ];
    };
  };
}
