{
  description = "A Nix flake template for a jupyter notebook development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f { pkgs = import nixpkgs { inherit system; }; });

    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            venvDir = "./.venv";
            shellHook = "
            echo 'Entering a jupyter notebook shell template'
          ";
            packages =
              with pkgs;
              [
                nodejs_22
                nodePackages.npm
              ]
              ++ (with pkgs.python3Packages; [
                ipython
                venvShellHook
                virtualenv
                pip

                numpy
                jupyterlab
                matplotlib
                notebook
              ]);
            postVenvCreation = ''
              unset SOURCE_DATE_EPOCH
              pip install -r requirements.txt
            '';
            postShellHook = ''
              # allow pip to install wheels
              unset SOURCE_DATE_EPOCH
            '';
          };
        }
      );
    };
}
