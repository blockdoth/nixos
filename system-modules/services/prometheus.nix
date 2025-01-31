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
#  services.nginx = {
#     enable = true;
#     recommendedProxySettings = true;
#     recommendedOptimisation = true;
#     recommendedGzipSettings = true;
#     # recommendedTlsSettings = true;

#     upstreams = {
#       "grafana" = {
#         servers = {
#           "127.0.0.1:${toString config.services.grafana.port}" = {};
#         };
#       };
#       "prometheus" = {
#         servers = {
#           "127.0.0.1:${toString config.services.prometheus.port}" = {};
#         };
#       };
#     };

#     virtualHosts ={
#       grafana = {
#       locations."/" = {
#         proxyPass = "http://grafana";
#         proxyWebsockets = true;
#       };
#       listen = [{
#         addr = "192.168.1.10";
#         port = 8010;
#       }];
#       };
#       prometheus = {
#         locations."/".proxyPass = "http://prometheus";
#         listen = [{
#           addr = "192.168.1.10";
#           port = 8020;
#         }];
#       };
#     };
#   };
