{pkgs ? import <nixpkgs> {}}:
  pkgs.mkShell{
  shellHook = "
    echo 'Entering rust shell template'
    ";
	buildInputs =
	with pkgs; [
	  
	];
}