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
  mediaDir = cfg.mediaDir;
  mediaGroup = cfg.mediaGroup;
  streamUser = cfg.users.streamer;
in
{
  options = {
    system-modules.services.jellyseer.enable = lib.mkEnableOption "Enables jellyseer";
  };

  config = lib.mkIf config.system-modules.services.jellyseer.enable {
    services.jellyseer = {
      enable = true;
      port = 5055;
    };
  };
}
