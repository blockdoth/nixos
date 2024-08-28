{pkgs ? import <nixpkgs> {}}:
  pkgs.mkShell{
  shellHook = "
    echo 'Entering typescript shell template'
    ";
	buildInputs =
	with pkgs; [
	  
	];
}