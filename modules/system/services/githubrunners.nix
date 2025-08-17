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
    sops.secrets.github-runner-token = { };

    services.github-runners = {
      chatgertui-runner = {
        enable = true;
        name = "chatgertui-runner";
        url = "https://github.com/blockdoth/chatger-tui";
        tokenFile = config.sops.secrets.github-runner-token.path;
      };
    };
  };
}
