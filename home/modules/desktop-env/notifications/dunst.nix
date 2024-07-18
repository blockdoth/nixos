{ pkgs, config, lib, ... }:
{
  options = {
    notifications.dunst.enable = lib.mkEnableOption "Enables dunst";
  };

  config = lib.mkIf config.notifications.dunst.enable {
    services.dunst = {
      enable = true;
    };
  };
}
    
