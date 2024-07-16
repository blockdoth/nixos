{ config, lib, ... }:
{
  options = {
    power.laptop.enable = lib.mkEnableOption "Enables laptop power management";
  };

  config = lib.mkIf config.power.laptop.enable {

  };

}