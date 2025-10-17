{
  config,
  lib,
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
