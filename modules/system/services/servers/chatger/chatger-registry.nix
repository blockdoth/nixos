{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.servers.chatger-registry;
  domain = config.system-modules.services.network.domains.homelab;
  reggerPort = 8231;
  regger = inputs.chatger-registry.packages.${pkgs.system}.default;
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      regger
    ];
    users.groups.regger = { };

    users.users.regger = {
      isSystemUser = true;
      group = "chatger";
    };

    systemd.services.chatger-registry = {
      description = "chatger-registry";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${regger}/bin/regger serve -db /var/lib/chatger/chatger.db -p ${builtins.toString reggerPort}";
        WorkingDirectory = "${regger}/bin";
        StateDirectory = "regger";
        Restart = "on-failure";
        User = "regger";
        Group = "chatger";
        UMask = "0002";
      };
    };

    system-modules.services.network.reverse-proxy.proxies = [
      {
        subdomain = "chatger-registry";
        port = reggerPort;
        extra-config = ''
          transport http {
            versions 1.1
          }
        '';
      }
    ];
  };
}
