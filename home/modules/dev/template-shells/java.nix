{pkgs ? import <nixpkgs> {}}:
  pkgs.mkShell{
  shellHook = "
    echo 'Entering java shell template'
    ";
	buildInputs =
	with pkgs; [

	];
}