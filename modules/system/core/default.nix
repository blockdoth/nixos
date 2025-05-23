{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./env.nix
    ./boot.nix
    ./localization.nix
    ./networking.nix
    ./nix-config.nix
    ./impermanence.nix
    ./secrets.nix
    ./ssh.nix
    ./tailscale.nix
  ];
}
