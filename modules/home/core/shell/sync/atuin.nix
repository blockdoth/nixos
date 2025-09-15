{
  pkgs,
  config,
  lib,
  hostname,
  ...
}:
let
  module = config.modules.core.shell.sync.atuin;
in
{
  config = lib.mkIf module.enable {
    programs.atuin = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        auto_sync = true;
        sync_address = "https://atuin.insinuatis.com";
        sync.records = true;
        sync_frequency = "5m";
        key_path = config.sops.secrets.atuin-key.path;
      };
      flags = [
        "--disable-up-arrow"
        "--disable-ctrl-r"
      ];
    };
  };
}
