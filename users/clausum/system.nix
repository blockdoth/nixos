{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.system-modules.users.clausum;
in
{
  config = lib.mkIf module.enable {

    sops.secrets.blockdoth-password.neededForUsers = true;
    security.sudo.wheelNeedsPassword = false;
    programs.fish.enable = true;

    users = {
      mutableUsers = false;
      users.clausum = {
        isNormalUser = true;
        shell = pkgs.fish;
        hashedPasswordFile = config.sops.secrets.blockdoth-password.path;
        extraGroups = [
          "networkmanager"
          "audio"
          "wheel"
        ];
      };
    };
  };
}
