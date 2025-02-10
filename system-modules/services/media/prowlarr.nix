{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  domain = config.system-modules.services.domains.homelab;
  cfg = config.system-modules.services.mediaserver;
  mediaDir = cfg.dataDir;
  mediaGroup = cfg.group;
  torrentUser = cfg.users.torrenter;
  streamerUser = cfg.users.streamer;
in
{
  options = {
    system-modules.services.prowlarr.enable = lib.mkEnableOption "Enables prowlarr";
  };

  config = lib.mkIf config.system-modules.services.prowlarr.enable {
    # uses port 9696
    services.prowlarr = {
      enable = true;
      # group = mediaGroup;
    };
  };
}
