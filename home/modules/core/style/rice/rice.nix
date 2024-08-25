{ pkgs, ... }:
{
  imports = [
    ./fastfetch.nix
  ];

  home.packages = with pkgs; [
    cmatrix
    fortune
    cowsay
    fastfetch
    pipes
    cava
    cbonsai
    tty-clock
    btop
  ];
}
  
  
  
  
