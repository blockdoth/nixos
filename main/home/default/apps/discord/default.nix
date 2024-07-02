{pkgs, ...}: {
  home.packages = with pkgs; [
    vesktop
    discord
  ];
}
