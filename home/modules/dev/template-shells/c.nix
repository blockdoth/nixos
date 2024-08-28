{pkgs ? import <nixpkgs> {}}:
  pkgs.mkShell{
  shellHook = "
    echo 'Entering c shell template'
    ";
	buildInputs =
	with pkgs; [

	];
}