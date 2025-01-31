{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.flake-programs-sqlite.nixosModules.programs-sqlite ];
  options = {
    system-modules.common.nix-config.enable = lib.mkEnableOption "Enables default nix config settings";
  };

  config = lib.mkIf config.system-modules.common.nix-config.enable {
    environment.systemPackages = [
      pkgs.nixfmt-rfc-style
      pkgs.cachix
      (pkgs.writeShellApplication {
        name = "rebuild";
        text = builtins.readFile ./rebuild.sh;
      })
      (pkgs.writeShellApplication {
        name = "rebuild";
        text = builtins.readFile ./rebuild-penger.sh;
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
      package = pkgs.nixVersions.stable;
      settings = {
        cores = 11;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [ "@wheel" ];
        auto-optimise-store = true;
        http-connections = 50;
        warn-dirty = false;
        log-lines = 50;
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
      gc = {
        automatic = false;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
  };
}
