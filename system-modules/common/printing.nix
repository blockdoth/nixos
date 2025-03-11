{ config, lib, ... }:
let
  module = config.system-modules.common.printing;
in
{
  config = lib.mkIf module.enable {
    services.printing.enable = true;
  };
}
