{
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.display.wayland;
in
{
  imports = [ inputs.hyprland.nixosModules.default ];

  config = lib.mkIf module.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
