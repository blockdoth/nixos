{ config, lib, pkgs, ... }:
{
  options = {
    nix-config.enable = lib.mkEnableOption "Enables default nix config settings";
  };

  config = lib.mkIf config.nix-config.enable {
    nixpkgs.config.allowUnfree = true;
    nix = {
      package = pkgs.nixFlakes;
      settings = {
        cores = 11;
        experimental-features = [ "nix-command" "flakes" ];
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