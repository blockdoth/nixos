{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = config.system-modules.common.keyboard;
in
{
  config = lib.mkIf module.enable {
    services = {
      udev.packages = [ pkgs.via ];
      hardware.openrgb = {
        enable = true;
        startupProfile = "default";
      };
    };
    hardware.keyboard.qmk.enable = true;

    environment.systemPackages = with pkgs; [
      via
      qmk
    ];
  };
}
