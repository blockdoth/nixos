{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.loki = {
      enable = lib.mkEnableOption "Enables loki";
      port = lib.mkOption { type = lib.types.str; };
    };
  };

  config = lib.mkIf config.system-modules.services.loki.enable {
    system-modules.services.loki.port = "3100";
    services.loki = {
      enable = true;
      configuration = {
        auth_enabled = true;
      };
      extraFlags = [
        "--server.http-listen-port=${config.system-modules.services.loki.port}"
      ];
    };
  };
}
