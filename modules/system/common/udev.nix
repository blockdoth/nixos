{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = config.system-modules.common.udev;
in
{
  config = lib.mkIf module.enable {
    services.udev.packages = with pkgs; [
      platformio-core
      openocd
    ];
  };
}
