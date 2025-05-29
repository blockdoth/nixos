{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.system-modules.users.blockdoth;
in
{
  config = lib.mkIf module.enable {
    security.sudo.wheelNeedsPassword = false;
    sops.secrets.blockdoth-password.neededForUsers = true;

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
          "dialout" # For serialW
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
    # Needed for system level config of shell
    programs.fish.enable = true;
  };
}
