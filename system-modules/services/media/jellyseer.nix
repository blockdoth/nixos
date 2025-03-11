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
  mediaDir = cfg.mediaDir;
  mediaGroup = cfg.mediaGroup;
  streamUser = cfg.users.streamer;
  module = config.system-modules.services.media.jellyseer;
in
{
  config = lib.mkIf module.enable {
    services.jellyseer = {
      enable = true;
      port = 5055;
    };
  };
}
