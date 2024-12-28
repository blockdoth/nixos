{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    modules.programs.activate-linux.enable = lib.mkEnableOption "Enables activate-linux";
  };

  config = lib.mkIf config.modules.programs.activate-linux.enable {
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
