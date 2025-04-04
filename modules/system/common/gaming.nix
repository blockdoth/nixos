{ config, lib, ... }:
let
  module = config.system-modules.common.gaming;
in
{
  config = lib.mkIf module.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "amdgpu" ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = true;
    };
  };
}
