{ ... }:
{
  imports = [ 
    ./hardware.nix 
    ./modules/localisation
    ./modules/nix-config
    ./modules/ssh
  ];
}