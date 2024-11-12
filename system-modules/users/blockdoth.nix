{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    system-modules.users.blockdoth.enable = lib.mkEnableOption "enables user blockdoth";
  };

  config = lib.mkIf config.system-modules.users.blockdoth.enable {
    security.sudo.wheelNeedsPassword = false;
    users.users.blockdoth = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "sharedhome"
      ];
    };

    #TODO move to home manager
    programs = {
      fish.enable = true;
    };
  };
}
