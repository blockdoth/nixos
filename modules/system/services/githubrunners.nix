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
      githubrunner-1-token = { };
      githubrunner-2-token = { };
    };

    users.groups.githubrunners = { };
    users.users.githubrunners = {
      isSystemUser = true;
      group = "githubrunners";
      description = "GitHub Actions Runner User";
      home = "/var/lib/githubrunners";
      createHome = true;
    };

    services.github-runners = {
      chatgertui-runner-1 = {
        enable = true;
        name = "runner 1";
        url = "https://github.com/blockdoth/chatger-tui";
        tokenFile = config.sops.secrets.githubrunner-1-token.path;
        user = "githubrunners";
        group = "githubrunners";
      };
      chatgertui-runner-2 = {
        enable = true;
        name = "runner 2";
        url = "https://github.com/blockdoth/chatger-tui";
        tokenFile = config.sops.secrets.githubrunner-2-token.path;
        user = "githubrunners";
        group = "githubrunners";
      };
    };
  };
}
