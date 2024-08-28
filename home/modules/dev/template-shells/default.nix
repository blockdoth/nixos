{pkgs ? import <nixpkgs> {}}:
  pkgs.mkShell{
  shellHook = "
    echo 'Entering default shell template'
    ";
	buildInputs =
	with pkgs; [
	  
	];
}