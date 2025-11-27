{
  config,
  lib,
  ...
}:
let
  module = config.system-modules.services.attic;
  domain = config.system-modules.secrets.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    sops.secrets = {
      attic-env = { };
    };

    services.atticd = {
      enable = true;
      environmentFile = config.sops.secrets.attic-env.path;
      settings = {
        listen = "127.0.0.1:7543";
      };
    };

    system-modules.services = {
      network.reverse-proxy.proxies = [
        {
          domain = "${domain}";
          port = 7543;
        }
      ];
    };
  };
}
