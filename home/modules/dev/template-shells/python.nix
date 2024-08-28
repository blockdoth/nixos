{pkgs ? import <nixpkgs> {}}:
  pkgs.mkShell{
  shellHook = "
    echo 'Entering python shell template'
    ";
	buildInputs =
	with pkgs; [
	  
	];
}