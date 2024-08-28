{ pkgs, ... }:
{
  imports = [
    ./fastfetch.nix
    ./cava.nix
  ];

  home.packages = with pkgs; [
    cmatrix
    fortune
    cowsay
    fastfetch
    pipes
    cbonsai
    tty-clock
    lolcat
    mesa-demos # gears and such
  ];
}
  
  
  
  
