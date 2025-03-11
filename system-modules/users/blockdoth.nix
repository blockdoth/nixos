{
  pkgs,
  lib,
  config,
  ...
}:
let
  module = config.system-modules.users.blockdoth;
in
{
  config = lib.mkIf module.enable {
    sops.secrets.blockdoth-password = {
      neededForUsers = true;
    };

    security.sudo.wheelNeedsPassword = false;

    users = {
      mutableUsers = false;
      users.blockdoth = {
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
              (builtins.readFile ../../hosts/phone/id_ed25519.pub)
            ];
          };
        };
      };
    };

    #TODO move to home manager
    programs = {
      fish.enable = true;
    };
  };
}
