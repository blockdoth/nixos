{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.scraping.connectbox;

  connectboxSrc = pkgs.fetchFromGitHub {
    owner = "mbugert";
    repo = "connectbox-prometheus";
    rev = "master";
    sha256 = "";
  };

  mach-nix = import (pkgs.fetchFromGitHub {
    owner = "DavHau";
    repo = "mach-nix";
    rev = "3.5.0";
    sha256 = "sha256-j/XrVVistvM+Ua+0tNFvO5z83isL+LBgmBi9XppxuKA=";
  }) { };

  pythonEnv = mach-nix.mkPython {
    python = pkgs.python311;
    requirements = builtins.readFile "${connectboxSrc}/resources/requirements/production.txt";
  };

  # connectboxExporter = pkgs.stdenv.mkDerivation {
  #   pname = "connectbox-exporter";
  #   version = "0.0.1";
  #   src = connectboxSrc;

  #   nativeBuildInputs = [ pythonEnv ];

  #   buildPhase = ''
  #     ${pythonEnv.interpreter} setup.py build
  #   '';

  #   installPhase = ''
  #     ${pythonEnv.interpreter} setup.py install --prefix=$out
  #   '';
  # };
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      # connectboxExporter
    ];
  };
}
