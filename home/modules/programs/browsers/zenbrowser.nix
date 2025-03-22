{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.browsers.zenbrowser;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [ inputs.zen-browser.packages."${system}".default ];
  };
}
