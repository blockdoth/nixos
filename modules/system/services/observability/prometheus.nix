{
  config,
  lib,
  ...
}:
let
  module = config.system-modules.services.observability.prometheus;
in
{
  config = lib.mkIf module.enable {
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
        {
          job_name = "caddy";
          static_configs = [
            {
              targets = [
                "127.0.0.1:2019" # caddy metrics port
              ];
            }
          ];
        }
        {
          job_name = "immich";
          static_configs = [
            {
              targets = [
                "127.0.0.1:2283"
              ];
            }
          ];
        }
      ];
    };

    # shouldnt be exposed
    # services.caddy = {
    #   virtualHosts."prometheus.${domain}".extraConfig = ''
    #     reverse_proxy 127.0.0.1:${builtins.toString config.services.prometheus.port}
    #   '';
    # };
  };
}
