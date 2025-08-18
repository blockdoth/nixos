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
<<<<<<< HEAD
    environment.systemPackages = [
      pkgs.xz # For decompressing cache between runs
    ];
=======
>>>>>>> 9982bf3 ([nuc@penger] (02:18:01 25.11) System Generation 283)

    sops.secrets = {
      githubrunner-chatger-tui-token = { };
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
      chatgertui-runner = {
        enable = true;
        name = "chatger-tui runner";
        url = "https://github.com/blockdoth/chatger-tui";
<<<<<<< HEAD
        tokenFile = config.sops.secrets.githubrunner-chatger-tui-token.path;
=======
        tokenFile = config.sops.secrets.githubrunner-1-token.path;
        user = "githubrunners";
        group = "githubrunners";
        extraPackages = [ pkgs.xz ];
      };
      chatgertui-runner-2 = {
        enable = true;
        name = "runner 2";
        url = "https://github.com/blockdoth/chatger-tui";
        tokenFile = config.sops.secrets.githubrunner-2-token.path;
>>>>>>> 9982bf3 ([nuc@penger] (02:18:01 25.11) System Generation 283)
        user = "githubrunners";
        group = "githubrunners";
        extraPackages = [ pkgs.xz ];
      };
    };
  };
}
