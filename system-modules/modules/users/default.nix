{ config, lib, ...}:
{
  imports = [
    ./blockdoth.nix
    ./headless.nix
  ];

  programs = {
    fish.enable = true; 
  };
}
