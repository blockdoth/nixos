{pkgs, lib, ...}: {

  home.packages = with pkgs; [
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
