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
      domain = "insinuatis.com";
    in
    lib.mkIf config.system-modules.services.prometheus.enable {
      services.prometheus = {
        enable = true;
        port = 3020;
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
        enable = true;
        virtualHosts."prometheus.${domain}".extraConfig = ''
          reverse_proxy http://127.0.0.1:${builtins.toString config.services.prometheus.port}        
        '';
      };
    };
}
