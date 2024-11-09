{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    system-modules.common.nix-config.enable = lib.mkEnableOption "Enables default nix config settings";
  };

  config = lib.mkIf config.system-modules.common.nix-config.enable {

    environment.systemPackages = [
      (pkgs.writeScriptBin "rebuildhome" ./rebuildhome.sh)
      (pkgs.writeScriptBin "rebuildnix" ./rebuildnix.sh)
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
      package = pkgs.nixFlakes;
      settings = {
        cores = 11;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
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
