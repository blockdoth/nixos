{  config, lib, ... }:
{
  options = {
    hyprland.enable = lib.mkEnableOption "Enables Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}