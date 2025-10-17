{
  config,
  lib,
  ...
}:
let
  module = config.system-modules.services.filebrowser;
in
{
  config = lib.mkIf module.enable {
    # services.filebrowser = {
    #   enable = true;
    #   openRegistration = false;
    #   openFirewall = false;
    #   port = 8889;
    # };

    system-modules.services.network.reverse-proxy.proxies = [
      {
        subdomain = "filebrowser";
        port = config.services.filebrowser.listenPort;
      }
    ];
  };
}
