{pkgs, lib, ...}: {

  home.packages = with pkgs; [
    helix
    jetbrains.clion
    jetbrains.webstorm
    jetbrains.pycharm-community
    jetbrains.idea-ultimate
    vscodium
   ];

	programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];  
  };  


}
