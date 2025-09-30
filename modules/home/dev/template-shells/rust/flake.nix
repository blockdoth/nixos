{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem =
        {
          system,
          ...
        }:
        let
          pkgs = import inputs.nixpkgs {
            overlays = [ inputs.rust-overlay.overlays.default ];
            inherit system;
          };
          toolchain = pkgs.rust-bin.fromRustupToolchainFile ./toolchain.toml;
        in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              rust-analyzer-unwrapped
              toolchain
            ];
            RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";
          };

          packages.default =
            pkgs:
            pkgs.rustPlatform.buildRustPackage {
              pname = "package";
              version = "0.1.0";
              src = ./.;
              cargoLock.lockFile = ./Cargo.lock;
              cargoToml = ./Cargo.toml;
              release = true;
              nativeBuildInputs = [ toolchain ];
            };
        };
    };
}
