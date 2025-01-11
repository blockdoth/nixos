{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.pihole.enable = lib.mkEnableOption "Enables pihole";
  };

  config = lib.mkIf config.system-modules.services.pihole.enable {
    # services.pihole = {
    #   enable = true;
    # }
  };
}
