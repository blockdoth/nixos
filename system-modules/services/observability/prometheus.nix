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
                  "localhost:${toString config.services.prometheus.exporters.node.port}"
                ];
              }
            ];
          }
          # {
          #   job_name = "pisslog";
          #   scrape_interval = "5m";
          #   file_sd_configs = [
          #     {
          #       files = [
          #         "/var/log/pisslog.prom"
          #       ];
          #       refresh_interval = "5m";
          #     }
          #   ];
          # }
        ];
      };

      services.caddy = {
        virtualHosts."prometheus.${domain}".extraConfig = ''
          reverse_proxy http://localhost:${builtins.toString config.services.prometheus.port}        
        '';
      };
    };
}
