{ config, lib, ... }:
let
  module = config.system-modules.common.wireshark;
in
{
  config = lib.mkIf module.enable {
    programs.wireshark.enable = true;
  };
}
