{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.core.utils.git.enable = lib.mkEnableOption "Enables git";
  };

  config = lib.mkIf config.modules.core.utils.git.enable {
    home.packages = with pkgs; [
      lazygit
      gitAndTools.git-lfs
    ];

    programs = {
      git = {
        enable = true;
        userName = "blockdoth";
        userEmail = "pepijn.pve@gmail.com";
        extraConfig = {
          init.defaultBranch = "main";
          push.autoSetupRemote = "true";
        };
      };
    };
  };
}
