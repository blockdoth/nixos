{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.activate-linux;
in
{
  config = lib.mkIf module.enable {
    home.packages = [ inputs.activate-linux.packages.${pkgs.system}.activate-linux ];

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
