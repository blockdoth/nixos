{ pkgs, config, lib, inputs, ... }:
let 
  activate-linux = inputs.activate-linux.packages.${pkgs.system}.activate-linux;
  activate-linux-script = pkgs.writeShellScriptBin "activate-activate-linux" ''
    echo "${activate-linux}"
    ${activate-linux}/bin/activate-linux
  '';

in
{
  options = {
    modules.programs.activate-linux.enable = lib.mkEnableOption "Enables activate-linux";
  };

  config = lib.mkIf config.modules.programs.activate-linux.enable {
    home.packages = [
      activate-linux
      activate-linux-script
    ];

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
