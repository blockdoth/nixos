{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  domain = config.system-modules.services.network.domains.homelab;
  cfg = config.system-modules.services.mediaserver;
  mediaDir = cfg.dataDir;
  mediaGroup = cfg.group;
  torrentUser = cfg.users.torrenter;
  module = config.system-modules.services.media.sonarr;
in
{
  config = lib.mkIf module.enable {
    # Uses port 8989
    services.sonarr = {
      enable = true;
      group = mediaGroup;
    };

    # Fix insecure dependency
    nixpkgs.config.permittedInsecurePackages = [
      "aspnetcore-runtime-6.0.36"
      "aspnetcore-runtime-wrapped-6.0.36"
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-wrapped-6.0.428"
    ];

    systemd.tmpfiles.rules = [
      "d ${mediaDir}/torrents/sonarr 0775 ${torrentUser} ${mediaGroup} -"
    ];
  };
}
