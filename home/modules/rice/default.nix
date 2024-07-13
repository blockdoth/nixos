{pkgs, ...}: {
  home.packages = with pkgs; [
    cmatrix
    cowsay
    neofetch
    btop
    pipes
    cava
  ];
}
