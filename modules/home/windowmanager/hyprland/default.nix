{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.windowmanager.hyprland;
in
{
  imports = [
    ./animations.nix
    ./autorun.nix
    ./envvars.nix
    ./input.nix
    ./layout.nix
    ./keybinds.nix
    ./plugins.nix
    ./windowrules.nix
    inputs.hyprland.homeManagerModules.default
  ];

  config = lib.mkIf module.enable {

    home.packages = with pkgs; [
      grimblast
      hyprpicker
      wl-clipboard
      wf-recorder
      wlr-randr # screen stuff

      brightnessctl # Control background
      playerctl # Control audio
      pavucontrol
      pulseaudio
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      settings = {
        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
        debug = {
          disable_logs = false;
        };
      };
    };
  };
}
