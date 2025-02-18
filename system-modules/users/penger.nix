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
    sops.secrets.penger-password = {
      neededForUsers = true;
    };

    users = {
      mutableUsers = false;
      users.penger = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        hashedPasswordFile = config.sops.secrets.penger-password.path;
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

    programs = {
      fish.enable = true;
    };
  };
}
