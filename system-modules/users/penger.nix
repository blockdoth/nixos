{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    system-modules.users.penger.enable = lib.mkEnableOption "enables penger user";
  };

  config = lib.mkIf config.system-modules.users.penger.enable {
    users.users.penger = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
  };
}
