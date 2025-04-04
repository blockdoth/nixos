{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.observability.loki;
in
{
  config = lib.mkIf module.enable {
    # system-modules.services.loki.port = "3100";
    services.loki = {
      enable = true;
      configFile = ./loki.yaml;
    };
  };
}
