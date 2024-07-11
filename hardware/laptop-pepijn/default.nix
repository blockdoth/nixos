{ ... }:
{
  imports = [ 
    ./hardware.nix 
    ./modules/localisation
    ./modules/nix-config
    ./modules/pipewire
    ./modules/bluetooth
    ./modules/ssh
  ];
}