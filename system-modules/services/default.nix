{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./immich.nix
    ./iss-piss-stream.nix
    ./minecraft.nix
    ./pihole.nix
    ./headscale.nix
    ./atuin.nix
  ];
}
