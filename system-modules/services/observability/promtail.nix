{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.promtail.enable = lib.mkEnableOption "Enables promtail";
  };

  config = lib.mkIf config.system-modules.services.promtail.enable {
    services.promtail = {
      enable = true;
      configFile = ./promtail.yaml;
    };
  };
}
