{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.githubrunners;
  domain = config.system-modules.services.network.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    sops.secrets = {
      githubrunner-trusted-1-token = { };
      githubrunner-trusted-2-token = { };
      githubrunner-untrusted-1-token = { };
    };

    users.groups.githubrunners = { };
    users.users.githubrunners = {
      isSystemUser = true;
      group = "githubrunners";
      description = "GitHub Actions Runner User";
      home = "/var/lib/githubrunners";
      createHome = true;
      shell = pkgs.bash;
    };

    services.github-runners = {
      chatgertui-trusted-1 = {
        enable = true;
        name = "trusted runner 1";
        url = "https://github.com/blockdoth/chatger-tui";
        tokenFile = config.sops.secrets.githubrunner-trusted-1-token.path;
      };
      chatgertui-trusted-2 = {
        enable = true;
        name = "trusted runner 2";
        url = "https://github.com/blockdoth/chatger-tui";
        tokenFile = config.sops.secrets.githubrunner-trusted-2-token.path;
      };
      chatgertui-untrusted-1 = {
        enable = true;
        name = "untrusted runner 1";
        url = "https://github.com/blockdoth/chatger-tui";
        tokenFile = config.sops.secrets.githubrunner-untrusted-1-token.path;
      };
    };
  };
}
