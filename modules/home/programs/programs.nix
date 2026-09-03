{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      signal-desktop
      obsidian
      zapzap
      inkscape
      gimp3
      blender
      anki

      qimgv
      vlc
      xeyes # To detect if wayland vs xwayland
      xev # Check keybinds
      gparted # partitioning
      zathura # pdf viewer
      waypipe # display forwarding
      qdirstat
      rclip # technically cli only, but need gui to be usefull
      mpv
    ];

    programs.spicetify = {
      enable = true;
      # enabledExtensions = with spicePkgs.extensions; [
      #   adblock
      #   # shuffle # shuffle+ (special characters are sanitized out of extension names)
      # ];
      theme = spicePkgs.themes.text;
      colorScheme = "Gruvbox";
    };
  };
}
