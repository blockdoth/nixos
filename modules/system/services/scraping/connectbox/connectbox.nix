{
  pkgs,
  config,
  lib,
  ...
}:
# NOT WORKING BECAUSE FUCK PYTHON

let
  module = config.system-modules.services.scraping.connectbox;
  connectboxExporter = pkgs.python3Packages.buildPythonApplication {
    pname = "connectboxExporter";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "mbugert";
      repo = "connectbox-prometheus";
      sha256 = "";
    };
    propagatedBuildInputs = builtins.attrValues (import ./python-packages.nix { inherit pkgs; });
  };
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = [
      connectboxExporter
    ];
  };
}
