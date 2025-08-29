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

    users = {
      mutableUsers = false;
      users.penger = {
        isNormalUser = true;
        shell = "/sbin/nologin";
        extraGroups = [
          "wheel"
          "networkmanager"
          "chatger"
        ];
        openssh.authorizedKeys.keys = [
          (builtins.readFile ../../hosts/desktop/id_ed25519.pub)
          (builtins.readFile ../../hosts/laptop/id_ed25519.pub)
          (builtins.readFile ../../hosts/phone-oneplus/id_ed25519.pub)
        ];
      };
    };
  };
}
