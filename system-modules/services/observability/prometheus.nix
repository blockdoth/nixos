{
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.prometheus.enable = lib.mkEnableOption "Enables prometheus";
  };

  config =
    let
      domain = config.system-modules.services.domains.iss-piss-stream;
    in
    lib.mkIf config.system-modules.services.prometheus.enable {
      services.prometheus = {
        enable = true;
        port = 3020;
        # checkConfig = "syntax-only"; # Because some file paths might not be valid yet at build time
        exporters = {
          node = {
            port = 3021;
            enabledCollectors = [ "systemd" ];
            enable = true;
          };
        };
        scrapeConfigs = [
          {
            job_name = "nodes";
            static_configs = [
              {
                targets = [
                  "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
                ];
              }
            ];
          }
        ];
      };

      services.caddy = {
        virtualHosts."prometheus.${domain}".extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString config.services.prometheus.port}        
        '';
      };
    };
}
