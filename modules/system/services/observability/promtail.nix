{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.observability.promtail;
in
{
  config = lib.mkIf module.enable {
    services.promtail = {
      enable = true;
      configFile = ./promtail.yaml;
    };
  };
}
