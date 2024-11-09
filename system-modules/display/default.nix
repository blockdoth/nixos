{  config, lib, pkgs, ...}:
{
  imports = [
    ./wayland.nix
    ./x11.nix
    ./greeter.nix
  ];
}