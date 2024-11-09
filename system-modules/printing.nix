{ config, lib, ... }:
{
  options = {
    system-modules.printing.enable = lib.mkEnableOption "Enables printing";
  };

  config = lib.mkIf config.system-modules.printing.enable { services.printing.enable = true; };
}
