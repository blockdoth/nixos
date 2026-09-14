{
  pkgs,
  config,
  lib,
  inputs,
  hostname,
  ...
}:
let
  module = config.modules.windowmanager.hyprland;
  # pluginPkgs = inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  config = lib.mkIf module.enable {

    home.packages = with pkgs; [
      grimblast
      hyprpicker
      wl-clipboard
      wf-recorder
      wlr-randr # screen stuff
      hyprshutdown

      brightnessctl # Control background
      playerctl # Control audio
      pavucontrol
      pulseaudio
    ];

    home.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      NIXOS_OZONE_WL = 1;
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      configType = "lua";
      extraLuaFiles = {
        "lua.animations" = ./config/animations.lua;
        "lua.keybinds" = ./config/keybinds.lua;
        "lua.style" = ./config/style.lua;
        "lua.input" = ./config/input.lua;
        "lua.monitors" = ./config/monitors.lua;
        "lua.rules" = ./config/rules.lua;
        "lua.plugins" = ./config/plugins.lua;
        "lua.autostart" = ./config/autostart.lua;
        "lua.env" = pkgs.writeText "env.lua" ''
          hl.env("XDG_SCREENSHOTS_DIR", "$HOME/pictures/screenshots/${hostname}")
        '';

      };

      plugins = [
        # pluginPkgs.hyprspace
      ];
    };
  };
}
