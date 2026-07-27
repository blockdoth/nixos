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

      case "$source_binary" in
        /nix/store/*/bin/webber) ;;
        *)
          echo "Expected a Nix store Webber binary" >&2
          exit 1
          ;;
      esac

      if [[ ! -x "$source_binary" ]]; then
        echo "Binary does not exist: $source_binary" >&2
        exit 1
      fi

      state_dir="/var/lib/webber"
      target="$state_dir/webber"
      new="$state_dir/webber.new"
      database="$state_dir/database.sqlite"

      install -d -o webber -g webber -m 0750 "$state_dir"

      systemctl stop webber.service || true

      # Preserve the database embedded in the old executable.
      if [[ -x "$target" ]]; then
        runuser -u webber -- "$target" exportdb "$database"
      fi

      install -o webber -g webber -m 0750 "$source_binary" "$new"

      if [[ -f "$database" ]]; then
        runuser -u webber -- "$new" loaddb "$database"
      fi

      mv -f "$new" "$target"

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
    users.users.webber-deploy = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        (builtins.readFile ../../../../hosts/desktop/id_ed25519.pub)
        (builtins.readFile ../../../../hosts/laptop/id_ed25519.pub)
      ];
    };
    security.sudo.extraRules = [
      {
        users = [ "webber-deploy" ];
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

        ExecCondition = "${pkgs.coreutils}/bin/test -x /var/lib/webber/webber";
        ExecStart = "/var/lib/webber/webber";

        Restart = "on-failure";
        RestartSec = 2;

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
