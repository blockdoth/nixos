{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.git;
  mail = config.modules.core.secrets.mails.personal;
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
        userEmail = "${mail}";
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
