{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.infra.git;
  mail = config.modules.secrets.mails.personal;
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
