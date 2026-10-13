{
  config,
  lib,
  pkgs,
  ...
}:
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

    environment.systemPackages = with pkgs; [
      beyond-all-reason
      (prismlauncher.override {
        # withWaylandGLFW = true;
        jdks = [
          jdk17
          jdk21
        ];
      })
    ];
  };
}
