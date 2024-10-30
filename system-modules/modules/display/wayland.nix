{  config, lib, ... }:
{
  options = {
    system-modules.hyprland.enable = lib.mkEnableOption "Enables Hyprland";
  };

  config = lib.mkIf config.system-modules.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}