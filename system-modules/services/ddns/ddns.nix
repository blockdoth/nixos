{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.services.ddns.enable = lib.mkEnableOption "Enables ddns";
  };

  config = lib.mkIf config.system-modules.services.ddns.enable {
    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "update-ip";
        runtimeInputs = [
          (pkgs.writeShellApplication {
            name = "update-ip-unwrapped";
            text = builtins.readFile ./update-ip.sh;
          })
        ];
        text = "sudo cat ${config.sops.secrets.cloudflare-ddns-api-token.path} | update-ip-unwrapped";
      })
    ];

  };
}
