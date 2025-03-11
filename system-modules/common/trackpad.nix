{ config, lib, ... }:
let
  module = config.system-modules.common.trackpad;
in
{
  config = lib.mkIf module.enable {
    services = {
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          naturalScrolling = true;
          scrollMethod = "twofinger";
        };
      };
    };
  };
}
