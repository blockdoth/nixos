{  config, lib, pkgs, ...}:
{
  imports = [
    ./grub.nix
    ./localisation.nix
    ./networking.nix
    ./nix-config.nix
  ];
}