{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  config = lib.mkIf module.enable {
    home.persistence."/persist/home/${config.home.username}" = {
      directories = [
        "backups"
        "nixos"
        "downloads"
        "music"
        "pictures"
        "documents"
        "repos"
        "sources"
        "temp"
        "videos"
        ".gnupg"
        ".ssh"
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
      ];
      allowOther = true;
    };
  };
}
