{
  config,
  lib,
  pkgs,
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
      nixd
      (pkgs.writeShellApplication {
        name = "rebuild";
        text = builtins.readFile ../../../rebuild.sh;
      })
    ];

    # skips slow cache rebuilds
    documentation.man.generateCaches = lib.mkForce false;

    nixpkgs.config.allowUnfree = true;
    programs = {
      nh = {
        enable = true;
      };
      nix-ld = {
        enable = true;
        libraries = [
          # I will know what to put here when it becomes a problem
        ];
      };
    };

    nix = {
      settings = {
        cores = 8;
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
          "https://install.determinate.systems"
          "https://hyprland.cachix.org"
          # "https://ros.cachix.org"
        ];
        trusted-public-keys = [
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          # "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
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
