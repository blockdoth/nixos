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

    users = {
      mutableUsers = false;
      users.deploy = {
        isNormalUser = true;
        shell = pkgs.bashInteractive;
        extraGroups = [ ];
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
