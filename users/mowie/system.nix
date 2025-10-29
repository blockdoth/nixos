{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.system-modules.users.mowie;
in
{
  config = lib.mkIf module.enable {

    sops.secrets.mowie-password.neededForUsers = true;
    programs.fish.enable = true;

    security.sudo.wheelNeedsPassword = false;

    users = {
      mutableUsers = false;
      users.mowie = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        hashedPassword = config.sops.secrets.mowie-password.path;
        openssh.authorizedKeys.keys = [
          (builtins.readFile ../../hosts/desktop/id_ed25519.pub)
          (builtins.readFile ../../hosts/laptop/id_ed25519.pub)
          (builtins.readFile ../../hosts/phone-oneplus/id_ed25519.pub)
        ];
      };
    };
  };
}
