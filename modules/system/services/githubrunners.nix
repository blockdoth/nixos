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
      githubrunner-chatger-tui-1-token = { };
      githubrunner-chatger-tui-2-token = { };
    };

    services.github-runners = {
      chatgertui-runner-1 = {
        enable = true;
        name = "chatgertui runner 1";
        url = "https://github.com/blockdoth/chatger-tui";
        tokenFile = config.sops.secrets.githubrunner-chatger-tui-1-token.path;
      };
      chatgertui-runner-2 = {
        enable = true;
        name = "chatgertui runner 2";
        url = "https://github.com/blockdoth/chatger-tui";
        tokenFile = config.sops.secrets.githubrunner-chatger-tui-2-token.path;
      };
    };
  };
}
