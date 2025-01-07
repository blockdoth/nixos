{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
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

  options = {
    modules.core.windowmanager.tiling.hyprland.enable = lib.mkEnableOption "Enables hyprland";
  };

  config = lib.mkIf config.modules.core.windowmanager.tiling.hyprland.enable {

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
      package = pkgs.hyprland; # hyprlandFlake or pkgs.hyprland
      xwayland.enable = true;

      settings = {
        debug = {
          disable_logs = false;
        };
      };
    };
  };
}
