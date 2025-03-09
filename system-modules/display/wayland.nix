{
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.display.hyprland.enable = lib.mkEnableOption "Enables Hyprland";
  };
  imports = [ inputs.hyprland.nixosModules.default ];

  config = lib.mkIf config.system-modules.display.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
