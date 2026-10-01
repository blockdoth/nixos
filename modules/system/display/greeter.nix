{
  config,
  lib,
  pkgs,
  ...
}:

let
  module = config.system-modules.display.autologin;
in
{
  config = lib.mkIf module.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet -r -t --cmd start-hyprland";
          user = "greeter";
        };
      };
    };
  };
}
