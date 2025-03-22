{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.infra.git;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      lazygit
      gitAndTools.git-lfs
    ];

    programs = {
      git = {
        enable = true;
        userName = "blockdoth";
        userEmail = "pepijn.pve@gmail.com";
        lfs.enable = true;
        extraConfig = {
          init.defaultBranch = "main";
          push.autoSetupRemote = "true";
          pull.rebase = "true";
        };
      };
    };
  };
}
