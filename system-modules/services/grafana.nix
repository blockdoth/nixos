{
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.grafana.enable = lib.mkEnableOption "Enables grafana";
  };

  config = lib.mkIf config.system-modules.services.grafana.enable {
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
          domain = "insinuatis.com";
          root_url = "https://insinuatis.com/grafana/";
          serve_from_sub_path = true;
        };
      };
    };
  };
}
