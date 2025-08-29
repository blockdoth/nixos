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

    sops.secrets.blockdoth-password.neededForUsers = true;
    security.sudo.wheelNeedsPassword = false;
    programs.fish.enable = true;

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
          "docker"
          "dialout" # For serialW
        ];
        openssh.authorizedKeys.keys = [
          (builtins.readFile ../../hosts/nuc/id_ed25519.pub)
          (builtins.readFile ../../hosts/laptop/id_ed25519.pub)
          (builtins.readFile ../../hosts/phone-oneplus/id_ed25519.pub)
        ];
      };
    };
  };
}
