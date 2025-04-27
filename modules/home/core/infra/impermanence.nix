{
  pkgs,
  inputs,
  config,
  ...
}:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];
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
}
