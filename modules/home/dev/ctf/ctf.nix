{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.dev.ctf;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      ghidra
      burpsuite
    ];
  };
}
