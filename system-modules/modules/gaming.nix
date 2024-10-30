{ config, lib, ...}:
{
  options = {
    system-modules.gaming.enable = lib.mkEnableOption "Enables services required for games";
  };

  config = lib.mkIf config.system-modules.gaming.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "amdgpu" ];
    
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true; 
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}