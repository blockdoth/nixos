{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.core.style.rice.activate-linux;
in
{
  config = lib.mkIf module.enable {
    home.packages = [ pkgs.activate-linux ];

    # systemd.user.services.activate-linux = {
    #   Unit = {
    #     Description = "Activate Linux Service";
    #   };
    #   Install = {
    #     WantedBy = [ "default.target" ];
    #   };

    #   Service = {
    #     ExecStart = "activate-activate-linux";
    #     Restart = "always";
    #     User = "blockdoth";
    #   };
    # };
  };
}
