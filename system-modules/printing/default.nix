{ config, lib, ... }:
{
  options = {
    printing.enable = lib.mkEnableOption "Enables printing";
  };

  config = lib.mkIf config.printing.enable {
    services.printing.enable = true;
  };
}