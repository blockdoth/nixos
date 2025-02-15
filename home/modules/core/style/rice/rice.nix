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
    tree
    figlet
    mesa-demos
    # mesa-demos # gears and such
  ];
}
