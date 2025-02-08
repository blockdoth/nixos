{
  pkgs,
  config,
  lib,
  hostname,
  ...
}:
{
  options = {
    modules.core.terminal.shell.sync.atuin.enable = lib.mkEnableOption "Enables atuin";
  };

  config = lib.mkIf config.modules.core.terminal.shell.sync.atuin.enable {
    programs.atuin = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        auto_sync = true;
        sync_address = "atuin.insinuatis.com";
        sync.records = true;
        sync_frequency = "5m";
        key_path = lib.mkIf (hostname != "laptop") config.sops.secrets.atuin-key.path;
      };
      flags = [
        "--disable-up-arrow"
        "--disable-ctrl-r"
      ];
    };
  };
}
