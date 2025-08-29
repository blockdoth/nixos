{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.system-modules.users.deploy;
in
{
  config = lib.mkIf module.enable {

    sops.secrets.deploy-password.neededForUsers = true;
    programs.fish.enable = true;

    users = {
      mutableUsers = false;
      users.deploy = {
        isNormalUser = true;
        extraGroups = [ ];
        hashedPasswordFile = config.sops.secrets.deploy-password.path;
        openssh.authorizedKeys.keys = [
          (builtins.readFile ../../hosts/desktop/id_ed25519.pub)
          (builtins.readFile ../../hosts/laptop/id_ed25519.pub)
          (builtins.readFile ../../hosts/phone-oneplus/id_ed25519.pub)
        ];
      };
    };
    security.sudo.extraRules = ''
      deploy ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/switch-to-configuration
      deploy ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/activate-profile
    '';
  };
}
