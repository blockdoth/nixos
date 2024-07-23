{ pkgs, config, lib, ... }:
{
  options = {
    compositor.wayland.applauncher.rofi.enable = lib.mkEnableOption "Enables rofi";
  };

  config = lib.mkIf config.compositor.wayland.applauncher.rofi.enable {

    programs.rofi = {
      package = pkgs.rofi-wayland;
      enable = true;
      theme = "Arc";
    };
  };
}