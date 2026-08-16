{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.system-modules.services.servers.webber;
  domain = config.system-modules.secrets.domains.public;

  webberPort = 4000;

  deployWebber = pkgs.writeShellApplication {
    name = "deploy-webber";

    runtimeInputs = with pkgs; [
      coreutils
      util-linux
      systemd
    ];

    text = ''
      set -euo pipefail

      source_binary="''${1:?usage: deploy-webber /nix/store/.../bin/webber}"

      [[ "$source_binary" == /nix/store/*/bin/webber ]] || {
        echo "Expected a Nix store Webber binary" >&2
        exit 1
      }

      [[ -x "$source_binary" ]] || {
        echo "Binary is not executable: $source_binary" >&2
        exit 1
      }

      state_dir=/var/lib/webber
      target="$state_dir/webber"
      new="$state_dir/webber.new"
      database="$state_dir/database.sqlite"

      install -d -o webber -g webber -m 0750 "$state_dir"
      install -o webber -g webber -m 0750 "$source_binary" "$new"

      systemctl stop webber.service || true

      runuser -u webber -- "$target" exportdb "$database"
      runuser -u webber -- "$new" loaddb "$database"
      mv -f "$new" "$target"

      rm "$database"

      systemctl start webber.service
      systemctl is-active --quiet webber.service

      echo "Deployed $source_binary"
    '';
  };
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = [
      deployWebber
    ];
    users.groups.webber = { };

    users.users.webber = {
      isSystemUser = true;
      group = "webber";
    };

    users.users.webber-deployer = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        (builtins.readFile ../../../../hosts/desktop/id_ed25519.pub)
        (builtins.readFile ../../../../hosts/laptop/id_ed25519.pub)
      ];
    };

    security.sudo.extraRules = [
      {
        users = [ "webber-deployer" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/deploy-webber";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
    systemd.services.webber = {
      description = "Webber";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        WEBBER_HOST = "127.0.0.1";
        WEBBER_PORT = toString webberPort;
        WEBBER_DOMAIN = domain;
      };

      serviceConfig = {
        User = "webber";
        Group = "webber";

        StateDirectory = "webber";
        WorkingDirectory = "/var/lib/webber";

        ExecStart = "${pkgs.util-linux}/bin/taskset -c 1 /var/lib/webber/webber";

        Restart = "on-failure";
        RestartSec = 2;
        StartLimitBurst = 5;

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";

        ReadWritePaths = [
          "/var/lib/webber"
        ];
      };
    };

    system-modules.services.network.reverse-proxy.proxies = [
      {
        domain = "${domain}";
        port = webberPort;
      }
    ];
  };
}
