{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.promtail.enable = lib.mkEnableOption "Enables promtail";
  };

  config = lib.mkIf config.system-modules.services.promtail.enable {
    services.promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_port = "9080";
          grpc_listen_port = "0";

        };
        positions = {
          filename = "/tmp/positions.yaml";
        };
        clients = {
          url = "http://localhost:${config.system-modules.services.loki.port}/loki/api/v1/push";
        };

        scrape_configs = [
          {
            job_name = "logs";
            static_configs = [
              {
                targets = [ "localhost" ];
                labels = {
                  job = "varlogs";
                  __path__ = "/var/log/pisslog.*";
                };
              }
            ];
          }
        ];
      };
    };
  };
}
