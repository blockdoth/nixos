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

  config = lib.mkIf config.system-modules.services.prometheus.enable {
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
  };
}
