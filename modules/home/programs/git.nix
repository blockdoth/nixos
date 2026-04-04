{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.programs.git;
  mail = config.modules.core.secrets.mails.personal;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      lazygit
      git-lfs
    ];

    programs = {
      git = {
        enable = true;
        lfs.enable = true;
        signing = {
          signByDefault = true;
          format = "ssh";
        };
        settings = {
          user = {
            name = "blockdoth";
            email = "${mail}";
            signingkey = "~/.ssh/id_ed25519";
          };
          init.defaultBranch = "main";
          push.autoSetupRemote = "true";
          pull.rebase = "true";
          core.editor = "micro";
        };
      };
    };
  };
}
