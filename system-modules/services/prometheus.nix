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
      # settings = {
      #   server = {
      #     http_addr = "127.0.0.1";
      #     http_port = 3000;
      #   };
      # };
    };
  };
}
