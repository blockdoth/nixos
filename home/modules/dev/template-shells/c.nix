{
  description = "A Nix flake template for a C development environment";

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
            # stdenv = pkgs.clangStdenv;  # Change standard compiler
            shellHook = "
            echo 'Entering C shell template'
          ";
            packages =
              with pkgs;
              [
                cmake
                gcc
                valgrind
              ]
              ++ (if system == "aarch64-darwin" then [ ] else [ gdb ]);
          };
        }
      );
    };
}
