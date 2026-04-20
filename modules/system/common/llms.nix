{
  config,
  pkgs,
  lib,
  ...
}:
let
  module = config.system-modules.common.llms;
in
{
  # NFS client mounts
  config = lib.mkIf module.enable {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
    };
  };
}
