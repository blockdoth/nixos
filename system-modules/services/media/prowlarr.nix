{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.prowlarr.enable = lib.mkEnableOption "Enables prowlarr";
  };

  config = lib.mkIf config.system-modules.services.prowlarr.enable {
    # uses port 9696
    services.prowlarr = {
      enable = true;
      group = mediaGroup;
    };
  };
}
