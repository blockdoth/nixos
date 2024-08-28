{ config, lib, ...}:
{
  options = {
    gaming.enable = lib.mkEnableOption "Enables services required for games";
  };

  config = lib.mkIf config.gaming.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "amdgpu" ];
    
    programs.steam = {
      enable = false;
      gamescopeSession.enable = true; 
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}