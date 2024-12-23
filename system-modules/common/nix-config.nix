{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];
  options = {
    system-modules.common.nix-config.enable = lib.mkEnableOption "Enables default nix config settings";
  };

  config = lib.mkIf config.system-modules.common.nix-config.enable {
    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "rebuild";
        runtimeInputs = [ pkgs.nixfmt-rfc-style ];
        text = builtins.readFile ./rebuild.sh;
      })
    ];

    # skips slow cache rebuilds
    documentation.man.generateCaches = false;

    # command not found database
    programs.nix-index.enable = true;

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
      package = pkgs.nixFlakes;
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
      };
      gc = {
        automatic = false;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
  };
}
