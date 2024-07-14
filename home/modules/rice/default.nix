{pkgs, ...}: {
  home.packages = with pkgs; [
    cmatrix
    fortune
    cowsay
    neofetch
    btop
    pipes
    cava
  ];
}
