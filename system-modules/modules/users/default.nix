{ config, lib, ...}:
{
  imports = [
    ./pepijn.nix
    ./headless.nix
  ];

  programs = {
    fish.enable = true; 
  };
}
