{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./env.nix
    ./grub.nix
    ./localization.nix
    ./networking.nix
    ./nix-config.nix
    ./secrets.nix
    ./ssh.nix
    ./tailscale.nix
  ];
}
