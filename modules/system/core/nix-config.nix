{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
let
  module = config.system-modules.core.nix-config;
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      nixfmt-tree
      cachix
      nix-output-monitor
      (pkgs.writeShellApplication {
        name = "rebuild";
        text = builtins.readFile ./rebuild.sh;
      })
    ];

    # skips slow cache rebuilds
    documentation.man.generateCaches = false;

    nixpkgs.config.allowUnfree = true;
    programs = {
      nh = {
        enable = true;
      };
      nix-ld = {
        enable = true;
        libraries = with pkgs; [
          # I will know what to put here when it becomes a problem
        ];
      };
    };

    nix = {
      settings = {
        cores = 11;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "@wheel"
          "githubrunners"
        ];
        auto-optimise-store = true;
        http-connections = 50;
        warn-dirty = false;
        log-lines = 50;
        substituters = [
          "https://hyprland.cachix.org"
          "https://install.determinate.systems"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
        ];
      };
      gc = {
        automatic = false;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
  };
}
