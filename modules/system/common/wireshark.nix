{ config, lib, ... }:
let
  module = config.system-modules.common.wireshark;
in
{
  config = lib.mkIf true {
    programs.wireshark.enable = true;
  };
}
