{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.immich.enable = lib.mkEnableOption "Enables immich";
  };

  config = lib.mkIf config.system-modules.services.immich.enable {
    # services.immich = {
    #   enable = true;
    # };
  };
}
