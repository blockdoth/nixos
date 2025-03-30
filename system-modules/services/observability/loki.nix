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

    services.gatus.settings.endpoints = [
      {
        name = "testos";
        url = "https://www.youtube.com";
        interval = "30s";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 500"
        ];
      }
    ];
  };
}
