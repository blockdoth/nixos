{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.githubrunners;
  domain = config.system-modules.secrets.domains.homelab;
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      xz
    ];

    sops.secrets = {
      githubrunner-chatger-tui-token = { };
      githubrunner-cv-token = { };
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
        tokenFile = config.sops.secrets.githubrunner-chatger-tui-token.path;
        user = "githubrunners";
        group = "githubrunners";

      };
      cv-runner = {
        enable = true;
        name = "typist cv runner";
        url = "https://github.com/blockdoth/cv";
        tokenFile = config.sops.secrets.githubrunner-cv-token.path;
        user = "githubrunners";
        group = "githubrunners";
      };
    };
  };
}
