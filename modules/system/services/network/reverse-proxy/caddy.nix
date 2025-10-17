{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.system-modules.services.network.reverse-proxy.caddy;
  proxies = config.system-modules.services.network.reverse-proxy.proxies;
  mailAddress = config.system-modules.secrets.mails.personal;
  makeReverseProxyHttps = http-proxy: {
    name = "${http-proxy.subdomain}.${http-proxy.domain}";
    value.extraConfig = ''
      ${
        if http-proxy.require-auth then
          ''
            forward_auth 127.0.0.1:${builtins.toString config.system-modules.services.auth.authelia.port} {
              uri /api/authz/forward-auth
              copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
            }
          ''
        else
          ""
      }
      reverse_proxy ${http-proxy.redirect-address}:${builtins.toString http-proxy.port} {
        ${http-proxy.extra-config}
      }
    '';
  };

  makeHelloWorld = domain: {
    name = domain;
    value = {
      extraConfig = ''
        respond "Hello World"
      '';
    };
  };

  domains = map (p: p.domain) proxies;
in
{
  config = lib.mkIf module.enable {

    environment.systemPackages = with pkgs; [
      goaccess # For logs
    ];

    users.users.caddy.extraGroups = [ "acme" ];

    services.caddy = {
      enable = true;
      email = mailAddress;

      virtualHosts =
        builtins.listToAttrs (map makeHelloWorld domains)
        // builtins.listToAttrs (map makeReverseProxyHttps proxies);

      globalConfig = ''
        metrics
      '';
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
