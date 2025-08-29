{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.system-modules.users.penger;
in
{
  config = lib.mkIf module.enable {

    sops.secrets.penger-password.neededForUsers = true;

    users = {
      mutableUsers = false;
      users.penger = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [
          "wheel"
          "networkmanager"
          "chatger"
        ];
        hashedPasswordFile = config.sops.secrets.penger-password.path;
        openssh = {
          authorizedKeys = {
            keys = [
              (builtins.readFile ../../hosts/desktop/id_ed25519.pub)
              (builtins.readFile ../../hosts/laptop/id_ed25519.pub)
              (builtins.readFile ../../hosts/phone-oneplus/id_ed25519.pub)
            ];
          };
        };
      };
    };
    # Needed for system level config of shell
    programs.fish.enable = true;
  };
}
