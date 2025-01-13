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

    sops.secrets.blockdoth-password.neededForUsers = true;
    users.mutableUsers = false;

    users.users.blockdoth = {
      isNormalUser = true;
      shell = pkgs.fish;
      hashedPasswordFile = config.sops.secrets.blockdoth-password.path;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
      ];
      openssh = {
        authorizedKeys = {
          keys = [
            (builtins.readFile ../../hosts/desktop/id_ed25519.pub)
            (builtins.readFile ../../hosts/laptop/id_ed25519.pub)
          ];
        };
      };
    };

    #TODO move to home manager
    programs = {
      fish.enable = true;
    };
  };
}
