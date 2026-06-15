{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  module = config.modules.dev.clin;
in
{

  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      inputs.clin.packages.${pkgs.stdenv.hostPlatform.system}.default
      glow
    ];
  };
}
