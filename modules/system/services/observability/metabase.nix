{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.observability.metabase;
in
{
  config = lib.mkIf module.enable {
    services.metabase = {
      enable = true;
      listen.port = 3000;
    };
  };
}
