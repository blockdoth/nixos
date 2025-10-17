{
  config,
  lib,
  ...
}:
let
  module = config.system-modules.services.httpbin;
  domain = config.system-modules.secrets.domains.homelab;
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
          require-auth = true;
          extra-config = ''
            header_up X-Forwarded-User {http.request.header.Remote-User}
            header_up X-Forwarded-Groups {http.request.header.Remote-Groups}
            header_up X-Forwarded-Email {http.request.header.Remote-Email}
          '';
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
