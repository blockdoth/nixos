{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixFlakes;
    settings = {
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
}