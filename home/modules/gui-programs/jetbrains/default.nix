{pkgs, lib, ...}: {

  home.packages = with pkgs; [
    jetbrains.clion
    jetbrains.webstorm
    jetbrains.pycharm-community
    jetbrains.idea-ultimate
   ];

}
