{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.system-modules.services.domains = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
  };
  config = {
    system-modules.services.domains = {
      iss-piss-stream = "insinuatis.com";
      homelab = "insinuatis.com";
    };
  };
}
