{
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.observability.gatus;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    services.gatus = {
      enable = true;
      settings = {
        web.port = 7070;
        alerting = {
          discord = {
            # webhook-url = "https://discord.com/api/webhooks/YOUR-WEBHOOK-URL";
          };
        };

        ui = {
          title = "My Gatus Dashboard";
          theme = "dark";
        };
        # security = {
        #   authentication = {
        #     username = "blockdoth";
        #     password-hash = "";
        #   };
        # };

        # tls = {
        #   certificate-file = "/etc/ssl/certs/gatus.crt";
        #   private-key-file = "/etc/ssl/private/gatus.key";
        # };

        endpoints = lib.mkMerge [ config.system-modules.services.observability.gatus.endpoints ];
      };
    };

    system-modules.services.observability.gatus.endpoints = lib.mkMerge [
      [
        {
          name = "test";
          url = "https://www.youtube.com";
          interval = "30s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 500"
          ];
        }
      ]
    ];

    services.caddy.virtualHosts."gatus.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${builtins.toString config.services.gatus.settings.web.port}
    '';
  };
}
