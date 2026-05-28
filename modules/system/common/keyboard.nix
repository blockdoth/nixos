{ config, lib, ... }:
let
  module = config.system-modules.common.keyboard;
in
{
  config = lib.mkIf module.enable {
    services.hardware.openrgb = {
      enable = true;
      startupProfile = "default";
    };
    hardware.keyboard.qmk.enable = false;
  };
}
