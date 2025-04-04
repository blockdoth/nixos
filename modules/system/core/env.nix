{
  config,
  lib,
  pkgs,
  ...
}:
let
  module = config.system-modules.core.networking;
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      home-manager
      micro
      git
    ];

    environment.variables = {
      EDITOR = "micro";
    };
  };
}
