{
  config,
  lib,
  ...
}:
let
  module = config.system-modules.services.network.fail2ban;
in
{
  config = lib.mkIf module.enable {
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      bantime-increment.enable = true;
    };
  };
}
